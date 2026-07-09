// Injected into the LinkedIn activity page
function injectExporterButton() {
  if (document.getElementById('kall-ai-exporter-btn')) return;

  const btn = document.createElement('button');
  btn.id = 'kall-ai-exporter-btn';
  btn.innerText = '📊 Export Analytics CSV';
  
  btn.addEventListener('click', scrapeAndExport);
  document.body.appendChild(btn);
  console.log("Kall AI Exporter: Injected floating button successfully.");
}

function scrapeAndExport() {
  console.log("Kall AI Exporter: Scraping feed items...");
  const posts = [];
  
  // LinkedIn post containers
  const feedItems = document.querySelectorAll('.feed-shared-update-v2, [data-urn^="urn:li:activity:"]');

  if (feedItems.length === 0) {
    alert("No posts found on the page. Please scroll down to load more activity posts!");
    return;
  }

  feedItems.forEach((item, index) => {
    // 1. Extract Post Content (Targeting the actual post body/commentary, avoiding actor headline)
    const textEl = item.querySelector('.feed-shared-update-v2__commentary, .feed-shared-update-v2__description-wrapper, .feed-shared-text-view, [class*="commentary"], [class*="update-v2__description"]');
    let text = '';
    if (textEl) {
      text = textEl.innerText.replace(/\n/g, ' ').trim();
    } else {
      // Fallback to general text container excluding actor header
      const alternativeTextEl = item.querySelector('.feed-shared-text');
      if (alternativeTextEl) {
        text = alternativeTextEl.innerText.replace(/\n/g, ' ').trim();
      }
    }
    
    // If text is empty or still just headline, try to find the specific text node
    if (!text || text.includes("Founder of Kall AI")) {
      const textBlock = item.querySelector('.feed-shared-update-v2__text-view');
      if (textBlock) text = textBlock.innerText.replace(/\n/g, ' ').trim();
    }

    const truncatedText = text ? (text.slice(0, 120) + (text.length > 120 ? '...' : '')) : 'Interaction (Like/Comment/Repost)';

    // 2. Extract Impression Count (Using robust text-search for "impressions" or "views")
    let impressions = '0';
    const allElements = item.querySelectorAll('span, button, a, div, p');
    for (const el of allElements) {
      const txt = (el.innerText || '').toLowerCase();
      if (txt.includes('impression') || (txt.includes('views') && !txt.includes('video'))) {
        const num = txt.replace(/[^0-9]/g, '');
        if (num) {
          impressions = num;
          break;
        }
      }
    }

    // 3. Extract Reactions, Comments, and Reposts
    let reactions = '0';
    let comments = '0';
    let reposts = '0';
    
    const socialCountsEl = item.querySelector('.social-details-social-counts');
    if (socialCountsEl) {
      const links = socialCountsEl.querySelectorAll('button, a, span, li');
      links.forEach(link => {
        const txt = (link.innerText || '').toLowerCase();
        const num = txt.replace(/[^0-9]/g, '');
        if (num) {
          if (txt.includes('comment')) {
            comments = num;
          } else if (txt.includes('repost') || txt.includes('share')) {
            reposts = num;
          }
        }
      });
      
      const reactCountEl = socialCountsEl.querySelector('.social-details-social-counts__reactions-count');
      if (reactCountEl) {
        reactions = reactCountEl.innerText.replace(/[^0-9]/g, '') || '0';
      }
    }

    const urn = item.getAttribute('data-urn') || `index-${index}`;

    posts.push({ index: index + 1, urn, text: truncatedText, impressions, reactions, comments, reposts });
  });

  // Filter out duplicates (LinkedIn repeats items during infinite scroll)
  const uniquePosts = [];
  const seenUrns = new Set();
  posts.forEach(p => {
    if (!seenUrns.has(p.urn)) {
      seenUrns.add(p.urn);
      uniquePosts.push(p);
    }
  });

  // Convert to CSV string
  const csvRows = ["Index,Post Hook,Impressions,Reactions,Comments,Reposts"];
  uniquePosts.forEach((p, i) => {
    csvRows.push(`"${i + 1}","${p.text.replace(/"/g, '""')}","${p.impressions}","${p.reactions}","${p.comments}","${p.reposts}"`);
  });
  const csvString = csvRows.join("\n");
  const filename = `linkedin_premium_analytics_${Date.now()}.csv`;

  // Trigger background download API
  chrome.runtime.sendMessage({
    action: 'download_csv',
    csvString: csvString,
    filename: filename
  }, (response) => {
    if (response && response.success) {
      console.log("Kall AI Exporter: Download successfully routed through background service worker.");
    } else {
      console.warn("Kall AI Exporter: Background download failed, using local fallback...");
      runFallbackDownload(csvString, filename);
    }
  });
}

function runFallbackDownload(csvString, filename) {
  const blob = new Blob([csvString], { type: 'text/csv;charset=utf-8;' });
  const url = URL.createObjectURL(blob);
  
  const link = document.createElement("a");
  link.href = url;
  link.download = filename;
  
  link.addEventListener('click', (e) => {
    e.stopPropagation();
  }, { passive: true });

  document.body.appendChild(link);
  link.click();
  document.body.removeChild(link);
  URL.revokeObjectURL(url);
  console.log("Kall AI Exporter: Direct fallback download executed.");
}

// Watch for DOM changes to inject button
const observer = new MutationObserver(injectExporterButton);
observer.observe(document.body, { childList: true, subtree: true });
injectExporterButton();

chrome.runtime.onMessage.addListener((message, sender, sendResponse) => {
  if (message.action === 'download_csv') {
    console.log("Kall AI Background: Triggering download for", message.filename);
    
    // Convert CSV string to Data URL (base64) for secure, sandboxed chrome.downloads
    const base64Data = btoa(unescape(encodeURIComponent(message.csvString)));
    const dataUrl = `data:text/csv;base64,${base64Data}`;
    
    chrome.downloads.download({
      url: dataUrl,
      filename: message.filename,
      conflictAction: 'uniquify',
      saveAs: true
    }, (downloadId) => {
      if (chrome.runtime.lastError) {
        console.error("Kall AI Background: Download error:", chrome.runtime.lastError.message);
        sendResponse({ success: false, error: chrome.runtime.lastError.message });
      } else {
        console.log("Kall AI Background: Download started with ID:", downloadId);
        sendResponse({ success: true, downloadId });
      }
    });
    return true; // Keeps messaging channel open for asynchronous sendResponse
  }
});

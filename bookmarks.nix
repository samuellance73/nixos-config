[
  {
    name = "Bookmarks Toolbar";
    toolbar = true;
    bookmarks = [
      {
        name = "AI";
        url = "https://www.google.com/ai?q=%s";
        keyword = "@gai";
      }
      {
        name = "Wiki";
        url = "https://en.wikipedia.org";
        keyword = "w";
      }
      {
        name = "HackerNews";
        url = "https://hn.algolia.com/?dateRange=pastWeek&sort=byPopularity&type=story";
        keyword = "hn";
      }
      {
        name = "GitHub";
        url = "https://github.com";
        keyword = "gh";
      }
      {
        name = "Astral Codex Ten";
        url = "https://astralcodexten.com";
        keyword = "act";
      }
      {
        name = "Youtube";
        url = "https://youtube.com";
        keyword = "yt";
      }
      {
        name = "AI Studio";
        url = "https://aistudio.google.com/prompts/new_chat";
        keyword = "ai";
      }
      {
        name = "AI Studio (Account 2)";
        url = "https://aistudio.google.com/u/1";
        keyword = "ai1";
      }
      {
        name = "AI Studio (Account 3)";
        url = "https://aistudio.google.com/u/2";
        keyword = "ai2";
      }
      {
        name = "Settings";
        url = "about:preferences";
        keyword = "s";
      }
      {
        name = "Config";
        url = "about:config";
        keyword = "c";
      }
      {
        name = "Design Mode";
        url = "javascript:(function(){if(document.designMode==='on'){document.designMode='off';document.body.contentEditable='false';}else{document.designMode='on';document.body.contentEditable='true';}})();";
        keyword = "dm";
      }
      {
        name = "Video";
        url = "javascript:(function(){var v=document.querySelector('video');if(v){var s=prompt('Enter playback speed:',v.playbackRate);if(s){v.playbackRate=parseFloat(s);}}else{alert('No video found on this page.');}})();";
        keyword = "vp";

      }
      {
        name = "Profile";
        url = "about:profiles";
        keyword = "p";
      }
    
    ];
  }
]

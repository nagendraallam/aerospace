/* user.js
 * https://github.com/rafaelmardojai/firefox-gnome-theme/
 */

// Enable customChrome.css
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);

// Enable CSD
user_pref("browser.tabs.drawInTitlebar", true);

// Set UI density to normal
user_pref("browser.uidensity", 0);

// Keep Firefox's vertical-tab content area from adding its own rounded frame.
user_pref("sidebar.revamp.round-content-area", false);

// Match the current sidebar and vertical-tab layout.
user_pref("sidebar.verticalTabs", true);
user_pref("sidebar.visibility", "hide-on-close");
user_pref("browser.tabs.closeWindowWithLastTab", false);

// Preserve the current toolbar arrangement without copying profile data.
user_pref("browser.uiCustomization.state", "{\"placements\":{\"widget-overflow-fixed-list\":[\"downloads-button\",\"fxa-toolbar-menu-button\"],\"unified-extensions-area\":[],\"nav-bar\":[\"back-button\",\"forward-button\",\"stop-reload-button\",\"customizableui-special-spring1\",\"vertical-spacer\",\"urlbar-container\",\"customizableui-special-spring2\",\"reset-pbm-toolbar-button\",\"unified-extensions-button\"],\"TabsToolbar\":[\"tabbrowser-tabs\",\"new-tab-button\",\"smartwindow-group-tabs-button\",\"ai-window-toggle\"],\"vertical-tabs\":[],\"PersonalToolbar\":[\"import-button\",\"personal-bookmarks\"]},\"seen\":[\"reset-pbm-toolbar-button\",\"ai-window-toggle\",\"developer-button\",\"screenshot-button\",\"smartwindow-group-tabs-button\"],\"dirtyAreaCache\":[\"nav-bar\",\"vertical-tabs\",\"PersonalToolbar\",\"TabsToolbar\",\"widget-overflow-fixed-list\"],\"currentVersion\":28,\"newElementCount\":5}");


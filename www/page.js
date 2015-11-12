
var PAGE = {
    page: null,
    args: null,
	toolbarItems: null,

    initialize: function(page) {
        this.page = page;
        this.bindEvents();
    },
    // Bind Event Listeners
    //
    // Bind any events that are required on startup. Common events are:
    // 'load', 'deviceready', 'offline', and 'online'.
    bindEvents: function() {
        document.addEventListener('deviceready', this.onDeviceReady, false);
    },
    // deviceready Event Handler
    //
    // The scope of 'this' is the event. In order to call the 'pageInit'
    // function, we must explicity call 'PAGE.pageInit(...);'
    onDeviceReady: function() {
        PAGE.pageInit('deviceready');
    },

    pageInit: function(id) {
        this.startThePageMan();
    },

    startThePageMan: function () {
        LIGER.getPageArgs();
    },

    gotPageArgs: function(args){
        this.args = args;
        this.common();
        this[this.page]();
    },

    common: function(){
		this.addToolbar();
    },

    addToolbar: function(){
        if (PAGE.toolbarItems != null) {
            PAGE.toolbar(PAGE.toolbarItems);
        }
    },

    /**
     * Opens a new page.
     * @iOS Pushes a UIViewController to a UINavigationController.
     * 
     * @param title The title of the page (title in UINavigationBar on iOS)
     * @param page The 'name' of the page to be open. Should not include html.
     * @param args json that will be sent to page
     */
    
    //PAGE.openPage('Second Page', 'secondPage', {'test1': 'test2'}, {});

    openPage: function(title, page, args, options) {
    
        LIGER.openPage(title, page, args, options); },

    /**
     * Closes the currently open page.
     *
     * Can't close a top level page.
     */
    closePage: function() { LIGER.closePage(); },

    /**
     * Closes all pages above 'page' in the navigation stack
     *
     * Can't close a top level page.
     */
    closeToPage: function(page) { LIGER.closeToPage(page); },

    /**
     * Sends arguments to the parent page.
     *
     * @param args Arguments you want to be sent to childUpdates on the parent page.
     */
    updateParent: function(args) { LIGER.updateParent(args); },

    /**
     * Sends arguments to the parent page.
     *
     * @param page The name of the first parent page (not including yoursef) you want to send the arguments to
     * @param args Arguments you want to be sent to childUpdates on the parent page.
     */
    updateParentPage: function(page, args) { LIGER.updateParentPage(page, args); },

    /**
     * Called on the parent of a page that called updateParent
     *
     * @param args The arguments from updateParent
     */ 
    childUpdates: function(args){},

    /**
     * Opens a new page as a dialog
     * @iOS Presents a UIViewController.
     * 
     * @param page The 'name' of the page to be open. Should not include html.
     * @param args json that will be sent to openPageArguments
     */
    openDialog: function(page, args, options){ LIGER.openDialog(page, args, options); },

    /**
     * Opens a new page as a dialog
     * @iOS Presents a UIViewController.
     * 
     * @param title The title of the page (title in UINavigationBar on iOS)
     * @param page The 'name' of the page to be open. Should not include html.
     * @param args json that will be sent to openPageArguments
     */
    openDialogWithTitle: function(title, page, args, options) { LIGER.openDialogWithTitle(title, page, args, options); },

    /**
     * Closes a page in an open dialog
     * @iOS Dismisses the current UIViewController
     * 
     * @param args json argument to send back to page that opened the dialog by calling closeDialogArguments
     *
     * Sending {"resetApp": true} will reset the app. Use when closing a signout page, advertiser selection page, or similar.
     *
     */
    closeDialog: function(args) { LIGER.closeDialog(args); },

    /**
     * Called from a page in a dialog being closed.
     *
     * @param args json arguments from the dialog being closed.
     */
    closeDialogArguments: function(args){ PAGE.startThePageMan(); },
    
    /**
     * Sets the toolbar items.
     * @param items An array of hashes, one per item. They keys are icon: character, callback: javascript code in a string to be executed when the item is tapped.
     */
    toolbar: function(items) { LIGER.toolbar(items); },

    headerButtonTapped: function(button) {}
	
};
module.exports = PAGE;



const sidebar = {
    sidebarOpen: true,
    toggleSidebar: function() {
        if (this.sidebarOpen) {
            this.closeNav();
            this.sidebarOpen = false;
        } else {
            this.openNav();
            this.sidebarOpen = true;
        }
    },
    closeNav: function() {
        document.getElementById("mySidebar").style.minWidth = "0";
        document.getElementById("mySidebar").style.maxWidth = "0";
    },
    openNav: function() {
        document.getElementById("mySidebar").style.minWidth = "320px";
        document.getElementById("mySidebar").style.maxWidth = "320px";
    }
};

export default sidebar;

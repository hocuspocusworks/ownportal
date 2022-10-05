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
        if (window.innerWidth < 720) {
            document.getElementById("mySidebar").style.minWidth = window.innerWidth + 'px'
            document.getElementById("mySidebar").style.maxWidth = window.innerWidth + 'px'
        } else {
            document.getElementById("mySidebar").style.minWidth = "320px";
            document.getElementById("mySidebar").style.maxWidth = "320px";
        }
    }
};

export default sidebar;

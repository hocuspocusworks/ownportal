import config from "./config";

const sidebar = {
    sidebarOpen: true,
    cutoffWidth: 720,
    toggleSidebar: function() {
        if (!this.activated()) {
            return;
        }

        if (this.sidebarOpen) {
            this.closeNav();
            this.sidebarOpen = false;
        } else {
            this.openNav();
            this.sidebarOpen = true;
        }
    },
    closeNav: function() {
        if (window.innerWidth <= this.cutoffWidth) {
            document.getElementById("mySidebar").setAttribute('class', 'd-none')
            document.getElementById("myContent").setAttribute('class', 'w-100 bg-dark-middle')
        } else {
            document.getElementById("mySidebar").style.minWidth = "0";
            document.getElementById("mySidebar").style.maxWidth = "0";
        }
    },
    openNav: function() {
        if (window.innerWidth <= this.cutoffWidth) {
            document.getElementById("mySidebar").setAttribute('class', 'w-100 text-white bg-dark-strong')
            document.getElementById("myContent").setAttribute('class', 'd-none')
        } else {
            document.getElementById("mySidebar").style.minWidth = "320px";
            document.getElementById("mySidebar").style.maxWidth = "320px";
        }
    },
    activated: function() {
        if (config.isToggleOn() || window.innerWidth < this.cutoffWidth) {
            return true
        }
        return false
    }
};

export default sidebar;

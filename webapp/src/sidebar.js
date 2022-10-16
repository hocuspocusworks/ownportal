import config from "./config";

const sidebar = {
    sidebarOpen: true,
    cutoffWidth: 720,
    toggleSidebar: function() {
        if (!this.activated()) {
            return;
        }

        if (this.sidebarOpen) {
            this.closeNav()
            this.sidebarOpen = false
        } else {
            this.openNav()
            this.sidebarOpen = true
        }
    },
    closeNav: function() {
        if (window.innerWidth <= this.cutoffWidth) {
            document.getElementById("mySidebar").classList.add('d-none')
            document.getElementById("myContent").classList.add('w-100')
            document.getElementById("mySidebar").classList.remove('w-100')
            document.getElementById("myContent").classList.remove('d-none')
            document.getElementById("bottomNav").classList.add('d-md-none')
            document.getElementById("bottomNav").classList.remove('d-none')
        } else {
            document.getElementById("mySidebar").style.minWidth = "0"
            document.getElementById("mySidebar").style.maxWidth = "0"
        }
    },
    openNav: function() {
        if (window.innerWidth <= this.cutoffWidth) {
            document.getElementById("mySidebar").classList.remove('d-none')
            document.getElementById("myContent").classList.remove('w-100')
            document.getElementById("mySidebar").classList.add('w-100')
            document.getElementById("myContent").classList.add('d-none')
            document.getElementById("bottomNav").classList.add('d-none')
            document.getElementById("bottomNav").classList.remove('d-md-none')
        } else {
            document.getElementById("mySidebar").style.minWidth = "320px"
            document.getElementById("mySidebar").style.maxWidth = "320px"
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

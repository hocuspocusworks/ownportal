import axios from 'axios';
import server from './.server';

const config = {
    gateway: server.gateway,
    path_location: 'gateway',
    paths: {
        'local': {
            'explore_categories': '',
            'my_feed': '/api/groups',
            'login': '/api/sessions',
            'rss_sources': '/api/rss/fetchAll',
            'streams': '/api/streams'
        },
        'gateway': {
            'explore_categories': '/portal/explore/categories',
            'explore_search': '/portal/api/explores/search',
            'explore_rss': '/portal/api/explores/rss',
            'my_feed': '/portal/api/groups',
            'login': '/login/api/sessions',
            'register': '/login/api/users',
            'rss_sources': '/portal/api/articles',
            'streams': '/portal/api/streams',
            'favourites': '/portal/api/favourites',
            'highlights': '/portal/api/highlights',
            'notifications': '/portal/api/notifications',
            'notification_count': '/portal/api/notification/count',
            'notification_read': '/portal/api/notification/read',
            'admin_sources': '/portal/api/admin/sources',
            'admin_categories': '/portal/api/admin/categories',
            'admin_stats': '/portal/api/admin/stats',
            'users': '/portal/api/users',
            'top': '/portal/api/explores/top',
            'spaces': '/portal/api/spaces',
            'blogs': '/portal/api/blogs',
            'histories': '/portal/api/histories'
        }
    },
    getPath(endpoint) {
        return this.paths[this.path_location][endpoint]
    },
    authorisationHeader() {
        return {'Authorization': localStorage.getItem('token')}
    },
    userId() {
        return localStorage.getItem('userId')
    },
    spaceId() {
        return localStorage.getItem('spaceId')
    },
    spacePath() {
        return localStorage.getItem('spacePath')
    },
    isAdmin() {
        return localStorage.getItem('sysadmin') === 'true' ? true : false
    },
    settings() {
        return localStorage.getItem('settings') ? localStorage.getItem('settings').split(',') : []
    },
    isToggleOn() {
        return false
    },
    isSafeSearchOn() {
        return this.settings().includes('safe')
    },
    isDarkModeOn() {
        return this.settings().includes('dark')
    },
    isSummaryViewOn() {
        return this.settings().includes('summary')
    },
    reload() {
        location.reload()
    },
    clearAll() {
        localStorage.removeItem('token')
        localStorage.removeItem('userId')
        localStorage.removeItem('sysadmin')
        localStorage.removeItem('spaceId')
        localStorage.removeItem('spacePath')
        localStorage.removeItem('settings')
    },
    setScreenSize() {
        localStorage.setItem('screenWidth', window.innerWidth)
        localStorage.setItem('screenHeigth', window.innerHeight)
    },
    fetchGroups(groups = undefined) {
        let userGroups = localStorage.getItem('userGroups')
        if (!groups && userGroups) {
            return userGroups.split(',')
        } else if (userGroups) {
            let elements = groups.map(group => group.name)
            localStorage.setItem('userGroups', elements)
        }
    },
    pullSettings() {
        if (!config.userId()) return;

        let url = this.gateway + this.getPath('users') + '/' + config.userId()
        axios.get(url, { headers: this.authorisationHeader() })
            .then(response => {
                if (response.status === 200) {
                    const settings = response.data.settings
                    const parsedSettings = typeof settings == 'string' ? JSON.parse(settings) : settings
                    localStorage.setItem('settings', parsedSettings)
                }
            })
    }
};

document.onkeydown = function(e) {
  if (e.key === '.' && (e.ctrlKey || e.metaKey)) {
    e.preventDefault()

    alert('open configuration')
  }
}

export default config;

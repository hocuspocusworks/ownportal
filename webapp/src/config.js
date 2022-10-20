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
            'rss_sources': '/rss/rss/fetchAll',
            'streams': '/portal/api/streams',
            'favourites': '/portal/api/favourites',
            'highlights': '/portal/api/highlights',
            'admin_sources': '/portal/api/admin/sources',
            'admin_categories': '/portal/api/admin/categories',
            'admin_stats': '/portal/api/admin/stats',
            'users': '/portal/api/users',
            'top': '/portal/api/explores/top',
            'blogs': '/portal/api/blogs'
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
    reload() {
        location.reload()
    },
    setScreenSize() {
        localStorage.setItem('screenWidth', window.innerWidth)
        localStorage.setItem('screenHeigth', window.innerHeight)
    },
    fetchGroups(groups = undefined) {
        if (groups === undefined) {
            return localStorage.getItem('userGroups').split(',')
        } else {
            let elements = groups.map(group => group.name)
            localStorage.setItem('userGroups', elements)
        }
    }
};

export default config;

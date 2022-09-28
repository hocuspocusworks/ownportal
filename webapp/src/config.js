const config = {
    gateway: 'http://localhost:8089',
    // gateway: "https://gateway.ownportal.net"
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
            'admin_sources': '/portal/api/admin/sources',
            'admin_categories': '/portal/api/admin/categories',
            'admin_stats': '/portal/api/admin/stats',
            'users': '/portal/api/users'
        }
    },
    getPath(endpoint) {
        return this.paths[this.path_location][endpoint]
    },
    authorisationHeader() {
        return {'Authorization': localStorage.getItem('token')}
    },
    settings() {
        return localStorage.getItem('settings') ? localStorage.getItem('settings').split(',') : []
    },
    isToggleOn() {
        return this.settings().includes('toggle')
    },
    isSafeSearchOn() {
        return this.settings().includes('safe')
    },
    isDarkModeOn() {
        return this.settings().includes('dark')
    }
};

export default config;

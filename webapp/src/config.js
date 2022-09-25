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
            'stream_create': '/api/streams'
        },
        'gateway': {
            'explore_categories': '/portal/explore/categories',
            'explore_search': '/portal/api/explores/search',
            'my_feed': '/portal/api/groups',
            'login': '/login/api/sessions',
            'rss_sources': '/rss/rss/fetchAll',
            'stream_create': '/portal/api/streams'
        }
    },
    getPath(endpoint) {
        return this.paths[this.path_location][endpoint]
    },
    authorisationHeader() {
        return {'Authorization': localStorage.getItem('token')}
    }
};

export default config;

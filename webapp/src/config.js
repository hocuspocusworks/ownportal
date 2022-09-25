const config = {
    gateway: 'http://localhost:3000',
    // gateway: "https://gateway.ownportal.net"
    path_location: 'local',
    paths: {
        'local': {
            'explore_categories': '',
            'my_feed': '/api/groups'
        },
        'gateway': {
            'explore_categories': '/portal/explore/categories',
            'my_feed': '/portal/feed/me'
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

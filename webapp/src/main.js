import { createApp } from "vue";
import App from "./App.vue";
import PrimeVue from 'primevue/config';
import router from './router/index.js';
import "./index.css";

// import 'primevue/resources/themes/saga-blue/theme.css';
import 'primevue/resources/themes/lara-light-blue/theme.css';
import 'primevue/resources/primevue.min.css';
import 'primeicons/primeicons.css';
import 'primeflex/primeflex.css';

const app = createApp(App);
app.use(router);
app.use(PrimeVue);
app.mount("#app");

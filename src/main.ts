import Vue from 'vue'
import './plugins/iview.js'
import './plugins/axios'
import App from './App.vue'
import router from './router'
import store from './store'
import moment from 'moment'
import * as filters from './assets/filter'
import { AxiosInstance } from "axios"; 

declare module "vue/types/vue" { interface Vue { $axios: AxiosInstance } }
Object.keys(filters).forEach(key => {
  Vue.filter(key, filters[key])
})

moment.locale('zh-cn')


Vue.config.productionTip = false

new Vue({
  router,
  store,
  render: h => h(App)
}).$mount('#app')

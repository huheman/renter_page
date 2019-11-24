"use strict";

import axios from "axios"
import iView from 'iview'
import {Vue} from 'vue-property-decorator'

// Full config:  https://github.com/axios/axios#request-config
// axios.defaults.baseURL = process.env.baseURL || process.env.apiUrl || '';
// axios.defaults.headers.common['Authorization'] = AUTH_TOKEN;
// axios.defaults.headers.post['Content-Type'] = 'application/x-www-form-urlencoded';

let config = {
  baseURL: "/api"
  // timeout: 60 * 1000, // Timeout
  // withCredentials: true, // Check cross-site Access-Control
};

const _axios = axios.create(config);

_axios.interceptors.request.use(
  function(config) {
    // Do something before request is sent
    return config;
  },
  function(error) {
    // Do something with request error
    return Promise.reject(error);
  }
);

// Add a response interceptor
_axios.interceptors.response.use(
  function(response) {
    // Do something with response data
    switch(response.data.resultFlag){
      case 0:
        iView.Message.error("服务器出错！")
        break;
      case 10000:
        // 10000是fail
        if (response.data.msg){
          let msg = response.data.msg
          let pos = msg.search('important:')
          if(pos>-1){
            msg = msg.substring(pos+10)
            iView.Modal.warning({
              title: '警告',
              content: msg
            });
          }else{
            iView.Message.info(response.data.msg)
          }
          
        }
        break;
      case 30000:
        // 30000是空
        let msg= '未找到数据'
        if(response.data.msg!=undefined){
          msg = response.data.msg
        }
        if(msg){
          iView.Message.info(msg)
        }
        break;
    }
    return response;
  },
  function(error) {
    // Do something with response error
    iView.Message.error("请求服务器出错！")
    return Promise.reject(error);
  }
);

// 把axios注册到Vue中。在其他地方可以直接this.$axios使用
Plugin.install = function(Vue, options) {
  Vue.axios = _axios;
  window.axios = _axios;
  Object.defineProperties(Vue.prototype, {
    axios: {
      get() {
        return _axios;
      }
    },
    $axios: {
      get() {
        return _axios;
      }
    },
  });
};

Vue.use(Plugin)

export default Plugin;

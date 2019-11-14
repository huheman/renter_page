module.exports = {
    publicPath: process.env.NODE_ENV === 'production'
        ? './'
        : '/',

    outputDir: 'dist',
    assetsDir: 'js',
    lintOnSave: false,
    productionSourceMap: process.env.NODE_ENV !== 'production',

    devServer: {
        disableHostCheck: true,
        port: 8087,
        proxy:{
          "/api":{
            changeOrigin: true,
            target: 'http://192.168.1.102:9090'
          }
        }
    },

    pluginOptions: {
      moment: {
        locales: [
          'zh-cn',
          'zh',
          'cn'
        ]
      }
    }
}

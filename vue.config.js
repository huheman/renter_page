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
        port: 8087
    },
}
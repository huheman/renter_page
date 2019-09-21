module.exports = {
    publicPath: process.env.NODE_ENV === 'production'
        ? './'
        : '/',
    outputDir: 'dist',
    assetsDir: 'js',
    lintOnSave: process.env.NODE_ENV !== 'production',
    productionSourceMap: process.env.NODE_ENV !== 'production',
    devServer: {
        port: 8087
    },
}
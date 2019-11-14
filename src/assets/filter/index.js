export function formatMoney(val) {
    console.log('inside='+val)
    if (val){
        return val.replace(/\B(?=(\d{3})+(?!\d))/g, ',')
    }
}
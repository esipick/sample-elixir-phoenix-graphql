export const setLSItem = (key, value) => {
    localStorage.setItem(key, JSON.stringify(value))
}

export const getLSItem = (key,) => {
    const item = JSON.parse(localStorage.getItem(key))
    if(item){
        return item
    } 
    return null;
}

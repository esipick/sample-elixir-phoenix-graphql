export const setLSItem = (key, value) => {
    localStorage.setItem(key,value)
}

export const getLSItem = (key,) => {
    const item = localStorage.getItem(key)
    if(item){
        return item;
    } 
    return null;
}

function Resource(title, url){
    var self = this
    self.title = ko.observable(title)
    self.link   = ko.observable(url)
}
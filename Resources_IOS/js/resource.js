function Resource(title, link){
    var self = this
    self.title = ko.observable(title)
    self.link  = ko.observable(link)
}
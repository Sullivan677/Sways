import UIKit

struct SectionAccount {
    let title: String?
    let rows: [Row]
}

struct Row {
    let title: String
    let subtitle: String?
    let URL: String?
}

var dataSource = [
SectionAccount(title: "About", rows: [Row(title: "Customer support", subtitle: "Chat with us", URL: "https://drift.me/sullivan"),
                               Row(title: "Instagram", subtitle: "Follow our journey", URL: "https://www.instagram.com/sways_app/"),
                               Row(title: "Become a partner", subtitle: "List your classes", URL: "https://sullivandecarli.typeform.com/to/fYkjp2")
    
]),
SectionAccount(title: "Legal", rows: [Row(title: "Terms & Conditions", subtitle: "Read our terms of services", URL: "https://sways.app/termsandconditions.html"),
                               Row(title: "Privacy Policy", subtitle: "How we proccess your datas", URL: "https://sways.app/privacypolicy.html")
    
])
]

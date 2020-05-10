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
SectionAccount(title: "About", rows: [Row(title: NSLocalizedString("Customer Support", comment: ""), subtitle: NSLocalizedString("Chat with us", comment: ""), URL: "https://drift.me/sullivan"),
                               Row(title: "Instagram", subtitle: NSLocalizedString("Follow our journey", comment: ""), URL: "https://www.instagram.com/sways_app/"),
                               Row(title: NSLocalizedString("Become a partner", comment: ""), subtitle: NSLocalizedString("List you classes", comment: ""), URL: "https://sullivandecarli.typeform.com/to/fYkjp2")
    
]),
SectionAccount(title: "Legal", rows: [Row(title: "Terms & Conditions", subtitle: NSLocalizedString("Read our terms of services", comment: ""), URL: "https://sways.app/termsandconditions.html"),
                               Row(title: "Privacy Policy", subtitle: NSLocalizedString("How we proccess your datas", comment: ""), URL: "https://sways.app/privacypolicy.html")
    
])
]

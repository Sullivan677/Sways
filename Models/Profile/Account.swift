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

SectionAccount(title: "About", rows: [Row(title: NSLocalizedString("Customer Support", comment: ""), subtitle: NSLocalizedString("Chat with us", comment: ""), URL: "https://apple.com"),
                               Row(title: "Instagram", subtitle: NSLocalizedString("Follow our journey", comment: ""), URL: "https://apple.com"),
                               Row(title: NSLocalizedString("Become a partner", comment: ""), subtitle: NSLocalizedString("List you classes", comment: ""), URL: "https://apple.com")
    
]),
    SectionAccount(title: "Legal", rows: [Row(title: "Terms & Conditions", subtitle: NSLocalizedString("Read our terms of services", comment: ""), URL: "https://apple.com"),
                                   Row(title: "Privacy Policy", subtitle: NSLocalizedString("How we proccess your datas", comment: ""), URL: "https://apple.com")
        
    ])

]

/// VoltSpare Official Legal Content & Policies
///
/// Compliant with:
/// - Consumer Protection Act, 2019
/// - Consumer Protection (E-Commerce) Rules, 2020
/// - Information Technology Act, 2000 & applicable rules
/// - Digital Personal Data Protection Act, 2023

class LegalConfig {
  static const String appName = 'VoltSpare';
  static const String appTagline =
      'Online Two-Wheeler Spare Parts | EV & Petrol';
  static const String effectiveDate = 'October 1, 2026';
  static const String lastUpdatedDate = 'October 1, 2026';
  static const String supportEmail = 'support@voltspare.com';
  static const String supportPhone = '+91 98765 43210';
  static const String grievanceEmail = 'grievance@voltspare.com';
  static const String grievanceOfficerName =
      'VoltSpare Grievance Redressal Officer';
  static const String grievanceAddress =
      'VoltSpare Operations & Redressal Cell, India';
  static const String governingLaw = 'The laws of the Republic of India';
  static const String jurisdiction =
      'Competent courts in India having jurisdiction, subject to applicable consumer protection laws and mandatory statutory forums';
}

class LegalSection {
  final String id;
  final String title;
  final String summary;
  final List<String> bulletPoints;
  final String? detailedText;

  const LegalSection({
    required this.id,
    required this.title,
    required this.summary,
    required this.bulletPoints,
    this.detailedText,
  });
}

class VoltSpareTermsAndConditions {
  static const String title = 'Terms & Conditions';
  static const String preamble =
      'Welcome to VoltSpare. These Terms and Conditions ("Terms") govern your access to and use of the VoltSpare mobile application, website, and related digital services (collectively, the "Platform"). By accessing, registering an account, or placing an order on VoltSpare, you agree to be bound by these Terms.';

  static const List<LegalSection> sections = [
    LegalSection(
      id: 'tc_1',
      title: '1. About VoltSpare',
      summary: 'Platform for EV and petrol two-wheeler spare parts.',
      bulletPoints: [
        'VoltSpare is an online e-commerce platform that enables customers to browse, discover, and purchase spare parts, components, accessories, and maintenance products for electric vehicles (EV) and petrol two-wheelers.',
        'We connect vehicle owners, mechanics, and enthusiasts with relevant vehicle parts through our digital catalog and fulfillment network.',
        'VoltSpare endeavors to provide accurate product listings and reliable fulfillment services in accordance with these Terms.',
      ],
      detailedText:
          'VoltSpare operates as a specialized online two-wheeler spare parts platform. While we partner with authorized suppliers and quality manufacturers, product specifications, warranties, and performance standards are governed by the respective manufacturer policies and product-level details provided on the Platform.',
    ),
    LegalSection(
      id: 'tc_2',
      title: '2. Account Registration & Security',
      summary:
          'User account requirements, information accuracy, and credentials.',
      bulletPoints: [
        'To access certain features, save vehicles, or place orders, you may register an account by providing accurate and complete information (including your name, mobile number, and email address).',
        'You are responsible for maintaining the confidentiality of your login credentials and OTPs, and for all activities that occur under your account.',
        'You agree to promptly update your account information in case of changes to your contact or address details.',
        'VoltSpare does not store raw passwords in plain text or display authentication secrets in unencrypted form.',
      ],
    ),
    LegalSection(
      id: 'tc_3',
      title: '3. Product Information & Fitment Compatibility',
      summary:
          'Vehicle fitment, product details, and compatibility verification.',
      bulletPoints: [
        'VoltSpare makes reasonable efforts to provide accurate product names, brand references, vehicle compatibility (by EV/petrol brand and model), pricing, technical descriptions, and images.',
        'Product images are for illustrative purposes and packaging or visual finish may occasionally vary depending on manufacturer batch updates.',
        'Vehicle fitment recommendations are provided as guidance based on catalog specifications. Customers are encouraged to verify vehicle model, variant, year of manufacture, and part dimensions prior to ordering.',
        'If you require assistance regarding part compatibility, our customer support and ticket assistance channels are available before order confirmation.',
      ],
    ),
    LegalSection(
      id: 'tc_4',
      title: '4. Product Availability & Hub Inventory',
      summary:
          'Location-based inventory, hub fulfillment, and availability status.',
      bulletPoints: [
        'Product availability and estimated delivery timelines may vary based on your selected delivery address, nearest fulfillment hub inventory, order timing, and logistics feasibility.',
        'If an item becomes unavailable or out of stock after order submission, VoltSpare will notify you promptly and process an appropriate refund or alternate arrangement with your consent.',
        'Same-day, next-day, or scheduled delivery options apply only where specifically marked and when both the item and delivery address qualify under hub operational capacity.',
      ],
    ),
    LegalSection(
      id: 'tc_5',
      title: '5. Pricing, Applicable Taxes & Invoicing',
      summary:
          'Transparent pricing, GST, delivery charges, and final payable amount.',
      bulletPoints: [
        'All prices are listed in Indian Rupees (INR) and clearly display applicable Good and Services Tax (GST), delivery charges, discounts, and the final net payable total at checkout.',
        'The final amount displayed on the order review screen before payment authorization is the amount payable for the order.',
        'Invoices with itemized tax breakdowns (CGST/SGST/IGST where applicable) are generated digitally upon order confirmation and accessible within your account order history.',
        'VoltSpare reserves the right to correct manifest pricing errors caused by technical malfunctions before order fulfillment, with notice and refund options provided to the customer.',
      ],
    ),
    LegalSection(
      id: 'tc_6',
      title: '6. Order Placement & Acceptance',
      summary:
          'Order submission, confirmation generation, and fulfillment process.',
      bulletPoints: [
        'Placing an order constitutes an offer to purchase the selected spare parts. Acceptance occurs when VoltSpare generates an order confirmation with a unique Order ID.',
        'VoltSpare may contact the customer via SMS, email, in-app notifications, or phone regarding order verification, address clarification, or delivery updates.',
        'If an order cannot be processed due to operational constraints, payment failure, or inventory shortage, the customer will be notified and any debited payment will be refunded to the original payment source.',
      ],
    ),
    LegalSection(
      id: 'tc_7',
      title: '7. Payment Processing & Gateway Security',
      summary:
          'Supported digital payments, COD options, and PCI-DSS compliance.',
      bulletPoints: [
        'VoltSpare supports verified payment methods including UPI, Debit/Credit Cards, Net Banking, and Cash on Delivery (COD) where eligible.',
        'Online transactions are processed through secure, authorized third-party payment gateways compliant with RBI guidelines and PCI-DSS standards.',
        'VoltSpare receives payment confirmation tokens and transaction reference IDs necessary to confirm orders and issue invoices. VoltSpare does NOT store complete card numbers, CVV codes, UPI PINs, or net banking passwords.',
      ],
    ),
    LegalSection(
      id: 'tc_8',
      title: '8. Delivery Logistics & Estimates',
      summary: 'Delivery timelines, distance estimation, and external factors.',
      bulletPoints: [
        'Delivery timelines depend on the delivery address, distance from the serving VoltSpare hub, item readiness, and operational conditions.',
        'Delivery estimates provided at checkout are reasonable estimates. VoltSpare strives to meet indicated timelines but is not liable for delays caused by adverse weather, traffic restrictions, natural events, or force majeure conditions.',
        'Customers must ensure that an authorized person is available to receive the shipment at the designated delivery address.',
      ],
    ),
    LegalSection(
      id: 'tc_9',
      title: '9. Hub Radius & Location-Based Serviceability',
      summary:
          'Latitude/longitude hub matching and tiered delivery fee calculation.',
      bulletPoints: [
        'VoltSpare utilizes the latitude and longitude associated with your delivery address solely to identify the closest fulfillment hub and verify whether the location falls within its operational service radius.',
        'The calculated radial distance between your delivery point and our hub determines delivery eligibility, slot options, and applicable delivery fees.',
        'Location data is processed for serviceability, routing, and order fulfillment only and is NOT used for continuous or intrusive background tracking.',
      ],
    ),
    LegalSection(
      id: 'tc_10',
      title: '10. Returns, Refunds, Exchanges & RMA',
      summary:
          'Product return eligibility, defective item replacements, and refund process.',
      bulletPoints: [
        'Return, refund, or Return Merchandise Authorization (RMA) eligibility depends on the product category, condition, and applicable policy.',
        'Items delivered with manufacturing defects, transit damage, or incorrect part shipments may be eligible for return or replacement within the communicated return window upon providing photographic or video proof.',
        'Electrical components (e.g., controllers, wiring harnesses, EV motor sensors) that have been installed, altered, or damaged due to improper installation are subject to technical evaluation before approval.',
        'Approved refunds are initiated to the original payment method or bank account within standard banking timelines (typically 5 to 7 business days).',
      ],
    ),
    LegalSection(
      id: 'tc_11',
      title: '11. Product Warranties',
      summary: 'Manufacturer warranties and product-specific terms.',
      bulletPoints: [
        'Where a spare part carries a manufacturer warranty or VoltSpare warranty, the specific warranty period and terms are stated on the product details page.',
        'Warranty claims require the original invoice and evidence of standard installation and operating conditions. Wear-and-tear items (such as brake pads, bulbs, and cables) carry limited coverage as specified by the manufacturer.',
      ],
    ),
    LegalSection(
      id: 'tc_12',
      title: '12. Customer Responsibilities',
      summary: 'Accurate details, fitment checks, and shipment inspection.',
      bulletPoints: [
        'Provide accurate contact numbers, recipient names, and precise delivery addresses including landmarks and pin codes.',
        'Verify vehicle compatibility, model specifications, and part numbers prior to placing the order.',
        'Inspect the delivered package at the time of receipt and report any outer damage or missing items promptly through VoltSpare support channels.',
      ],
    ),
    LegalSection(
      id: 'tc_13',
      title: '13. Prohibited Misuse & Fraud Prevention',
      summary:
          'Prohibition of fraudulent orders, unauthorized access, and malicious acts.',
      bulletPoints: [
        'Users must not create fraudulent accounts, submit false orders, or exploit technical bugs or promotional systems.',
        'Users must not attempt unauthorized access to VoltSpare servers, APIs, databases, or third-party integrations.',
        'Violations may lead to immediate account suspension, order cancellation, and reporting to relevant authorities under applicable Indian law.',
      ],
    ),
    LegalSection(
      id: 'tc_14',
      title: '14. Intellectual Property Rights',
      summary: 'VoltSpare branding, trademarks, and third-party OEM marks.',
      bulletPoints: [
        'The VoltSpare name, logo, application interface, visual assets, software code, and proprietary content are the exclusive intellectual property of VoltSpare.',
        'Third-party vehicle manufacturer names (e.g., Ather, Ola, TVS, Honda, Hero, Bajaj, Yamaha, etc.) and model marks are used strictly for compatibility identification and remain the property of their respective trademark holders.',
      ],
    ),
    LegalSection(
      id: 'tc_15',
      title: '15. Third-Party Services & Integrations',
      summary: 'Payment gateways, map APIs, and cloud services.',
      bulletPoints: [
        'VoltSpare integrates trusted third-party providers for payment gateway processing, mapping/geocoding services, cloud hosting, and SMS/notification delivery.',
        'Your use of services involving these providers is subject to their respective terms and privacy policies in addition to VoltSpare\'s Terms.',
      ],
    ),
    LegalSection(
      id: 'tc_16',
      title: '16. Service Availability & Maintenance',
      summary: 'Uptime efforts, routine updates, and temporary interruptions.',
      bulletPoints: [
        'VoltSpare endeavors to maintain uninterrupted platform availability. Routine maintenance, feature upgrades, or network outages may cause temporary downtime.',
        'We strive to schedule maintenance during off-peak hours and restore services expeditiously.',
      ],
    ),
    LegalSection(
      id: 'tc_17',
      title: '17. Statutory Consumer Rights Protection',
      summary: 'Compliance with Consumer Protection (E-Commerce) Rules, 2020.',
      bulletPoints: [
        'Nothing in these Terms excludes, restricts, or modifies any statutory consumer rights that cannot be lawfully excluded under Indian law, including the Consumer Protection Act, 2019 and the Consumer Protection (E-Commerce) Rules, 2020.',
        'VoltSpare maintains transparent trade practices regarding pricing, refunds, warranties, and grievance resolution.',
      ],
    ),
    LegalSection(
      id: 'tc_18',
      title: '18. Customer Support & Grievance Redressal',
      summary: 'Contact channels, grievance officer, and escalation path.',
      bulletPoints: [
        'For order inquiries, delivery assistance, or returns, contact our customer support team via in-app Support Tickets or by email at ${LegalConfig.supportEmail}.',
        'In compliance with Rule 5(3) of the Consumer Protection (E-Commerce) Rules, 2020, our appointed Grievance Officer details are:',
        'Officer: ${LegalConfig.grievanceOfficerName}',
        'Email: ${LegalConfig.grievanceEmail}',
        'Address: ${LegalConfig.grievanceAddress}',
        'Grievances are acknowledged within 48 hours and addressed in accordance with statutory guidelines.',
      ],
    ),
    LegalSection(
      id: 'tc_19',
      title: '19. Updates & Amendments to Terms',
      summary: 'Modifications, notifications, and continuous review.',
      bulletPoints: [
        'VoltSpare may update these Terms periodically to reflect business, operational, or legal changes.',
        'The "Last Updated" date at the top of these Terms will indicate the latest revision. Continued use of the Platform after updates signifies acceptance of revised Terms.',
      ],
    ),
    LegalSection(
      id: 'tc_20',
      title: '20. Governing Law & Dispute Resolution',
      summary: 'Neutral Indian legal jurisdiction and statutory forums.',
      bulletPoints: [
        'These Terms are governed by and construed in accordance with ${LegalConfig.governingLaw}.',
        'Any dispute arising out of or in connection with these Terms shall be subject to ${LegalConfig.jurisdiction}.',
      ],
    ),
  ];
}

class VoltSparePrivacyPolicy {
  static const String title = 'Privacy Policy';
  static const String preamble =
      'At VoltSpare, we respect your privacy and are committed to protecting your personal data. This Privacy Policy explains how we collect, use, process, store, and safeguard your personal information when you use the VoltSpare mobile app, website, and related services, in compliance with applicable Indian data protection laws including the Digital Personal Data Protection Act, 2023.';

  static const List<LegalSection> sections = [
    LegalSection(
      id: 'pp_1',
      title: '1. Information We Collect',
      summary: 'Account details, delivery addresses, and vehicle selections.',
      bulletPoints: [
        'Account Information: Name, mobile number, and email address provided during signup, login, or profile updates.',
        'Delivery Information: Recipient name, delivery phone number, full street address, pin code, and delivery notes required for order delivery.',
        'Vehicle & Preference Data: Saved vehicle brand, model, and fuel type (EV/Petrol) to tailor fitment suggestions and compatible part discovery.',
      ],
    ),
    LegalSection(
      id: 'pp_2',
      title: '2. Location Information & Hub Serviceability',
      summary:
          'Address latitude/longitude usage for delivery radius calculation.',
      bulletPoints: [
        'When you provide or select a delivery address, VoltSpare processes the associated latitude and longitude solely to identify the closest VoltSpare fulfillment hub.',
        'This location data is used to verify whether your address is within our hub service radius, estimate delivery transit distance, determine delivery slot availability, and compute delivery charges.',
        'VoltSpare does NOT perform continuous background location tracking. Device location permission, if requested, is used solely to assist you in selecting your delivery pin location.',
      ],
    ),
    LegalSection(
      id: 'pp_3',
      title: '3. Order, Invoice & Transaction Information',
      summary: 'Order records, purchased items, invoices, and support history.',
      bulletPoints: [
        'We collect details of products ordered, quantity, purchase prices, applicable GST, delivery fees, order status, and digital invoices.',
        'Communications, quotations, rare part requests, and support ticket messages exchanged through our in-app chat are recorded to facilitate customer service and warranty verification.',
      ],
    ),
    LegalSection(
      id: 'pp_4',
      title: '4. Payment Information Handling',
      summary:
          'Secure payment gateway processing; no raw banking secrets stored.',
      bulletPoints: [
        'Payments are processed via authorized payment gateway partners adhering to PCI-DSS standards and RBI security norms.',
        'VoltSpare receives payment confirmation tokens, transaction identifiers, and payment method categories (e.g., UPI, Card, Net Banking, COD).',
        'VoltSpare does NOT collect or store sensitive payment credentials such as card CVVs, debit/credit PINs, UPI PINs, or net banking passwords.',
      ],
    ),
    LegalSection(
      id: 'pp_5',
      title: '5. Purpose & Legal Basis for Data Processing',
      summary: 'How and why your personal data is utilized.',
      bulletPoints: [
        'To process and fulfill your orders, deliver spare parts, and issue tax invoices.',
        'To calculate accurate delivery charges and verify hub service radius coverage.',
        'To provide customer support, resolve tickets, and handle return/RMA requests.',
        'To prevent fraudulent transactions, protect account security, and ensure platform integrity.',
        'To comply with legal, accounting, tax (GST), and regulatory requirements under Indian law.',
      ],
    ),
    LegalSection(
      id: 'pp_6',
      title: '6. Data Sharing & Third-Party Processors',
      summary:
          'Necessary disclosures to logistics partners, payment processors, and authorities.',
      bulletPoints: [
        'Delivery & Logistics Partners: Sharing recipient name, contact number, and delivery address to execute physical delivery.',
        'Payment Gateways: Sharing transaction amounts and identifiers to process payments securely.',
        'Cloud Infrastructure & SMS/Communication Services: Secure hosting and transactional notification dispatch.',
        'Legal Compliance: Disclosing information where required by lawful government or judicial requests in India.',
        'VoltSpare does NOT sell, rent, or trade your personal data to third-party advertisers.',
      ],
    ),
    LegalSection(
      id: 'pp_7',
      title: '7. Data Retention Policy',
      summary:
          'Statutory accounting, tax, and order history retention periods.',
      bulletPoints: [
        'Personal data is retained for as long as your account remains active or as needed to provide fulfillment services.',
        'Order records, tax invoices, and transaction logs are retained for the statutory period required under Indian GST, taxation, and company law regulations.',
        'Support tickets and RMA history are retained for warranty and customer support continuity.',
      ],
    ),
    LegalSection(
      id: 'pp_8',
      title: '8. Technical & Organizational Security Measures',
      summary: 'Encryption, secure APIs, tokenization, and access controls.',
      bulletPoints: [
        'We implement industry-standard technical safeguards, including HTTPS/TLS encryption for all data in transit, secure token-based authentication, and role-based access restrictions.',
        'While we employ robust measures to safeguard information, no digital platform can guarantee absolute security. Users are encouraged to maintain confidential credentials.',
      ],
    ),
    LegalSection(
      id: 'pp_9',
      title: '9. User Rights & Choices (DPDP Act, 2023)',
      summary:
          'Rights to access, correct, update, withdraw consent, and grievance redressal.',
      bulletPoints: [
        'Access & Review: You may view your profile, saved addresses, and order history directly in the application.',
        'Correction & Updating: You can update your name, phone number, and delivery addresses via the Profile screen.',
        'Consent Withdrawal & Account Deletion: You may request account deactivation or withdraw consent for non-essential processing, subject to statutory retention obligations for financial/tax records.',
        'Grievance Redressal: You have the right to seek redressal for privacy-related concerns by contacting our designated Privacy Grievance Officer.',
      ],
    ),
    LegalSection(
      id: 'pp_10',
      title: '10. Protection of Children\'s Data',
      summary: 'Services intended for individuals competent to contract.',
      bulletPoints: [
        'VoltSpare does not knowingly collect personal data from minors under the age of 18 without parental or guardian consent.',
        'If you believe a minor has provided personal data without authorization, please notify us to take appropriate remedial steps.',
      ],
    ),
    LegalSection(
      id: 'pp_11',
      title: '11. Web Storage, Cookies & Local Preferences',
      summary:
          'Local storage usage for authentication tokens, vehicle filters, and cart.',
      bulletPoints: [
        'The VoltSpare Web and mobile applications utilize local storage and session tokens strictly to keep you securely signed in, remember your selected vehicle model, and preserve your shopping cart.',
        'We do not utilize intrusive cross-site tracking cookies for non-VoltSpare advertising.',
      ],
    ),
    LegalSection(
      id: 'pp_12',
      title: '12. Third-Party Links & Services',
      summary: 'External map providers and payment gateway portals.',
      bulletPoints: [
        'The Platform may interact with third-party service providers (such as map tiles for address selection and payment gateway web views).',
        'We encourage you to review the privacy notices of external providers when interacting with their hosted interfaces.',
      ],
    ),
    LegalSection(
      id: 'pp_13',
      title: '13. Changes to this Privacy Policy',
      summary: 'Periodic reviews and notification of material modifications.',
      bulletPoints: [
        'VoltSpare may update this Privacy Policy from time to time in response to evolving legal requirements or platform enhancements.',
        'Material updates will be notified through appropriate notices within the application or via email/SMS where required.',
      ],
    ),
    LegalSection(
      id: 'pp_14',
      title: '14. Contact & Privacy Grievance Redressal',
      summary: 'Direct contact with VoltSpare Privacy & Grievance team.',
      bulletPoints: [
        'For questions regarding this Privacy Policy, data access requests, or privacy concerns, please contact:',
        'Privacy Officer: ${LegalConfig.grievanceOfficerName}',
        'Email: ${LegalConfig.grievanceEmail}',
        'Support Email: ${LegalConfig.supportEmail}',
        'Address: ${LegalConfig.grievanceAddress}',
        'All privacy grievances are acknowledged within 48 hours and redressed in accordance with applicable laws.',
      ],
    ),
  ];
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants.dart';

class TermsPage extends StatefulWidget {
  const TermsPage({super.key});

  @override
  State<TermsPage> createState() => _TermsPageState();
}

class _TermsPageState extends State<TermsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants().primaryAppColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,color: Colors.white),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Terms And Conditions',
          style: GoogleFonts.poppins(
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Content('''Thank you for choosing AR DIGITAL SOLUTIONS. As used in this Terms of Services, “AR DIGITAL SOLUTIONS”, “us” and “we” refers to  AR DIGITAL SOLUTIONS Please read AR DIGITAL SOLUTIONS’ terms of services carefully as they contain important information regarding your legal rights and obligations as a customer. These include various limitations and exclusions and a binding arbitration agreement and class action waiver. The following terms govern your use of all AR DIGITAL SOLUTIONS services irrespective of the format. Please ensure to check regularly for updates to these terms of services. Your use of AR DIGITAL SOLUTIONS services indicate that you agree to the terms outlined in this legal document. Your continued use of our services also mean you are agreeing to any updates that might be made to these terms of services. If you do not agree with any of these terms, please do not use any of the AR DIGITAL SOLUTIONS services.'''),
              Heading('''Overview'''),
              Content('''This Software is developed and being run by AR DIGITAL SOLUTIONS. Therefore, this agreement is between you (“you” or “User” or “Client”) and AR DIGITAL SOLUTIONS. We provide access to this website, containing all services, information, and tools available to users, conditioned upon the acceptance of all terms and conditions stated below.
By signing up to use the AR DIGITAL SOLUTIONS( IKIA) app or services, you assent that you have read, are entitled, on behalf of yourself or your organization, to concur on, and do hereby accept on, the terms presented below.
'''           ),
              Heading('''Intellectual Property Right'''),
              Content(
                  '''AR DIGITAL SOLUTIONS owns all present and future Intellectual Property Rights including, but not limited to, any files, images incorporated in or generated, and data accompanying the services, collectively defined the “Software”. This refers to all non-tangible assets and any corresponding property rights under the laws of any jurisdiction including but not limited to creative works, designs, symbols, literary and artistic works, images, trade secrets, proprietary data, like customer lists and all products developed in whole or in part by AR DIGITAL SOLUTIONS. We may change the services or delete content or features at any time, in any way, for any or no reason.
Except if we specifically agree in writing, no content from any of our services may be copied, modified, used, reproduced, transmitted, distributed or otherwise exploited in any way other than as part of the services.
While you are using our services and software, we do not transfer the software title to you. You may not distribute or otherwise exploit the software or decompile, reverse engineer, disassemble or otherwise reduce the software to a human-readable form, sell, rent, distribute, disclose, permit access to, or transfer it to any third party.
'''
              ),
              Heading(
                '''Our Services''',
              ),
              Content(
                  '''The registration to any AR DIGITAL SOLUTIONS plans, either a free plan or a paid plan, will give you access to all the features and functions as outlined in the details of the plan. Any new feature upgrade to the plan will also be accessible to you at our discretion. This agreement only covers the current feature set per plan. AR DIGITAL SOLUTIONS reserves the right to make changes to its services at any time without any prior information to users. However, users might receive information about any significant changes.
By using our services, you agree that you will not submit, upload or write any content that:
1.	is defamatory, abusive, harassing, threatening, or an invasion of a privacy right of another person;
2.	is violent, vulgar, obscene, pornographic, or otherwise sexually explicit; or otherwise harms or can reasonably be expected to harm any person or entity;
3.	is illegal or encourages or advocates illegal activity or the discussion of illegal activities with the intent to commit them, including content that is, or represents an attempt of harassment, theft, or conspiracy to commit any criminal activity;
4.	infringes or violates any right of a third party including right of privacy (specifically, you must not distribute another person’s personal information of any kind without their permission) or publicity or any confidentiality obligation;
5.	contains a virus or other harmful component, or otherwise tampers with, impairs or damages the services or any connected network, or otherwise interferes with any person or entity’s use;
6.	is not related to the use of our services, and by using our services you send unsolicited or spam messages.
By uploading content, you warrant that the content and your communication thereof conform to the requirements of these terms and that you own or have the necessary rights, licenses, consents and permissions, without the need for any permission from or payment to any other person or entity, to exploit such content in all manners considered by these terms of services.
We reserve the right, but disclaim any obligation or responsibility, to refuse to post or remove any content from the services that violates these terms of services when we facilitate compliance with laws, including, for example, compliance with a court order, or help to protect the safety or security of any person or property, including our services. Moreover, we retain all rights to remove content at any time for any reason or no reason whatsoever.
We cannot and do not assure that other users are or will be complying with all or any of the provisions of these terms of services.
''',
              ),
              Heading('''Access Levels and Fees'''),
              Content('''The current annual or monthly fees for the AR DIGITAL SOLUTIONS paid plans are listed on the current pricing schedule. Full details of all subscription fees are available on the AR DIGITAL SOLUTIONS website. We reserve the right to change these fees from time to time, at which time we will notify users through the AR DIGITAL SOLUTIONS website, app or newsletter. Your subscription to our services will be renewed automatically based on the specified payment schedule per calendar month.
We offer all prospective users a free plan. There will be no charges for the use of free plan as long as this plan exists as an option on the AR DIGITAL SOLUTIONS platform. However, your free account on the system will be terminated after 6 months of inactivity (usage). We will also delete all data related to the inactive accounts.
AR DIGITAL SOLUTIONS has a mission to support churches so our free plans are free forever. We may cancel this in the future, but this will only apply to new accounts, not to old active accounts. Your Organization will be notified if this happens.
 The demo account is valid for thirty days after which it would no longer be accessible.
''',
              ),
              Heading('''Accounts'''),
              Content('''Our services require you to create an account. You agree to provide, maintain and update true, accurate, current and complete information about yourself. You shall not impersonate any person or entity or misrepresent your identity or affiliation with any person or entity, including using another person’s username, password or other account information, or another person’s name, likeness, or image.
On registering for an account, you will be required to provide an email and choose a password for your account. You are entirely responsible for the security and confidentiality of your email and password and agree not to share these details with any person who is not authorized to use your account. You also agree to promptly notify us of any unauthorized use of your username, password, other account information, or any other breach of security that you become aware of involving or relating to our services. In addition, you agree to exit from your account at the end of each session.
We may suspend or terminate your account and your ability to use the services for failure to comply with these terms of use or any special terms related to a particular service, for infringing copyright, or for any other reason whatsoever.
''',
              ),
              Heading('''Support and maintenance'''),
              Content('''AR DIGITAL SOLUTIONS shall, at its discretion, provide you with standard support and maintenance with respect to requests made via appropriate platforms including email, online chat and telephone only.'''),
              Heading('''Data Processing'''),
              Content('''AR DIGITAL SOLUTIONS is processing user’s data in accordance with our Privacy Policy and data privacy and protection applicable laws. If your church or ministry is EU based or subject to GDPR, we have set out a legal framework under which AR DIGITAL SOLUTIONS processes Personal Data for your church or ministry to be GDPR compliant when transferring user’s data to us. We are providing the Data Processing Addendum (DPA) that covers all Services offered by AR DIGITAL SOLUTIONS, and it comes in addition to these Terms of Services. Please read our DPA; by continuing to use our services you are agreeing to our DPA on behalf of your church or your ministry.'''),
              Heading('''Security of Services'''),
              Content('''You acknowledge that AR DIGITAL SOLUTIONS website, app, services and software is run over the internet and that the internet is generally an insecure public network, which means that there are inherent risks thereof. However, we will take all possible steps that a responsible and competent provider of services such as AR DIGITAL SOLUTIONS would be expected to take to maintain the security and integrity of all users’ data. Specifically, we will:
1.	take reasonable steps to ensure that AR DIGITAL SOLUTIONS is secure from unauthorized access by implementing administrative, physical and technical safeguards to protect your data in ways that are no less rigorous than accepted industry standards and security best practices;
2.	meet GDPR obligations in relation to data protection impact assessments, security of Processing and notification of Personal Data breaches.
3.	as soon as we become aware of any virus, malware, unauthorized access, or other harmful code that affects the services and software provided to you, immediately notify you and take all reasonable steps to tackle the problem, secure your content, remove the harmful code, as applicable, and take proactive steps to prevent future occurrences.
'''),
              Heading('''Disclaimer'''),
              Content('''The services are provided “as is” and without warranties of any kind. To the fullest extent permissible pursuant to applicable law, we disclaim all warranties, express or implied, including accuracy, completeness, availability, security, compatibility and noninfringement. We do not warrant that the services will be error-free, that access thereto will be uninterrupted, that defects will be corrected, or that any service are free of viruses or other harmful components. You hereby irrevocably waive any claim against us with respect to any information you provide to third party websites (including credit card and other personal information).
The Company will employ credible efforts to guarantee that the website and services are available 24 hours a day, 7 days a week. Upgrades, Maintenances, emergency repairs, and telecommunication failures may prohibit the availability of the website and services. Users agree that we are not going to be responsible for any incident that may happen to you or any other party for any discontinuance, suspension, amendment, or lack of availability of the website and the services.
Using the website through your mobile network means that terms of agreement with your mobile network provider will still apply. As a result, you may be charged for the cost of the connection by your mobile provider or any other third party. By using our app, you accept responsibility for such charges, including roaming data charges, if using our app outside your home country without turning off data roaming. If you are not the bill payer for the device on which you’re using our app, be aware that we assume you have received permission from the bill payer for using the app.
Under no circumstances, including negligence, shall we be liable to you or any other person or entity for any direct, indirect, incidental, special or consequential damages that result from the use of, or the inability to use, the services, or the conduct or actions, whether online or offline, of any user of the services or any other person or entity. In no event shall our total liability to you for all damages, losses and causes of action whether in contract, tort (including negligence) or otherwise exceed the amount paid by you, if any, for accessing or participating in any activity related to the services. Moreover, under no circumstances shall we be held liable for any delay or failure in performance resulting directly or indirectly from an act of force majeure or causes beyond our reasonable control.
Without prejudice to the generality of these terms of services, we:
•	do not warrant that the services or software or the website is/are fit for your purpose;
•	do not warrant that the software, services and website are free from errors;
•	do not warrant that the websites and/or services will be accessible without break downs.
You hereby agree to fully indemnify and hold harmless AR DIGITAL SOLUTIONS for any cost, expense, loss, damages, claims and liabilities howsoever caused that may arise in relation to your use of the website or the services.
The limitations, exclusions and disclaimers in this section and elsewhere in these terms of use apply to the maximum extent permitted by applicable law.
We make no claim that website or services are appropriate or available for use in any particular location. Those who choose to access the services do so on their own initiative, agree to these terms of services and are responsible for compliance with all applicable laws, including any applicable local laws.
If any provision of these terms of use shall be unlawful, void or for any reason unenforceable, then that provision shall be deemed dissociated from these terms of services and shall not affect the validity and enforceability of any remaining provisions.
'''),
              Heading('''Privacy'''),
              Content('''At AR DIGITAL SOLUTIONS, we take your privacy very seriously and respect your data privacy and protection rights and recognize the importance of protecting the personal information we collect about you.
Please refer to our Privacy Policy to find out more about how we collect, use, store and disclose your personal information and what your rights are.
'''),
              Heading('''Cookies'''),
              Content('''We use cookies to provide our services and our software. Our cookies help us provide customer service and support, protect and secure our clients and ourselves, create statistics to improve our services, and offer the user a pleasant experience when accessing our app, by allowing features such as language options, saving registration data, etc.
These cookies are necessary for our services to work properly on our app; if you do not agree with the use of cookies on our app then do not use any of the AR DIGITAL SOLUTIONS services.
We also use cookies on our website. The use of cookies does not involve personal data request and, in most cases, does not identify the users personally. For further information regarding the use of cookies on our website please read our Cookie Policy.
'''),
              Heading('''Changes to Terms and Services'''),
              Content('''Users can always review the most current version of the Terms of Service posted on this page. We solely have the right, at our own discretion, to change, replace or update any part of these Terms of Services by posting updates and changes to our website, app or services. It is the responsibility of users to periodically check our terms for amendments. Your continued use of or access to our website, app or services after the posting of any changes to these Terms of Services means your acceptance of those changes. Any changes to this Terms of Services will apply starting with the date on which it was made available, except the changes where your consent is expressly needed, in which case the changes will apply from the date of your consent.'''),
              Heading('''Contact Information'''),
              Content('''If you have any questions or suggestions regarding our Terms and Conditions, you can contact us free of charge here. We will respond to your request as soon as possible, but not later than 30 days.
 
Last modified on March 10, 2023.
 
 
 
FacebookTwitterYoutube
 
 
RECENT POSTS
•	Discover new ways to increase church giving
•	How to manage your volunteers
•	How to write and distribute church announcements
•	Signs of bad church leadership to watch out for
•	How to start a church a step-by-step guide
HELP & SUPPORT
•	Sign In
•	Sign Up
•	About us
•	Support
•	Contact Us
•	Terms of Services
•	Privacy Policy
•	Cookie Policy
'''),
              Heading('''PRIVACY POLICY regarding the processing of personal data'''),
              Content('''Last update: DATE
The purpose of this Privacy Policy is to explain how, when and why is your personal data processed by or through our website and app, as well as to inform you regarding the legal rights you have as a data subject related to the processing of your personal data.
This Privacy Policy does not consider the processing activities performed by our partners. Please check our partner’s privacy notices for information on the way they process your personal data as controllers
We are not responsible for the processing activities performed by the users of our website and/or app, or by the clients who benefit from our services, when they process personal data related to work, talents and hobbies, education, contact list, image, family members, contributions etc.
'''),
              SubHeading('''1.	WHO ARE WE?'''),
              Content('''The website www.ardigitalsolutions.co and the app 
____________________ are owned and administrated by IKIA, an  software company with head office in CHENNAI. As used in this Privacy Policy, “AR DIGITAL SOLUTIONS”, “us” and “we” refers to Jios Apps In
AR DIGITAL SOLUTIONS is a company that cares about helping churches and supporting their services through technology. We hope to improve the relationship between churches and members and are continuously working towards finding innovative tools that help servants perform their duties more effectively.
'''),
              SubHeading('''2.	DEFINITIONS'''),
              Content('''•	Personal data or personal information – means any information regarding an identified or identifiable natural person;
•	Controller – means the natural or legal person that determines the purposes and means of the processing of personal data processing. Regarding the personal data processing activities performed through the website and app, the Controller is IKIA, hereby referred to as “AR DIGITAL SOLUTIONS”, “us” or “we”;
•	Data subject – means the identified or identifiable natural person the personal data refers to, hereby referred to “you” or “your”;
•	Processing – means any operation or set of operations which is performed on personal data or on sets of personal data, whether or not by automated means, such as collection, storage, adaptation, consultation, use, disclose or deletion;
•	Consent of the Data subject – means any freely given, specific, informed and unambiguous indication of the user’s wishes by which he or she, by a statement or by a clear affirmative action, signifies agreement to the processing of personal data relating to him or her;
•	The Website – __________________;
•	The App – _________________ and the app available for Android and IOS;
•	Service – means providing access to the Website and App functionalities.
'''),
              SubHeading('''3.	HOW DO WE COLLECT PERSONAL DATA?'''),
              Content('''As a rule, the Personal Data we process is collected directly from you. However, there may be situations where data is collected indirectly from social media, from the website of the company you represent, from your employer as a contact person, from a third party who recommended you or from various public platforms (for example ad platforms).
When we, as a Controller, do not receive personal data directly from you as a user of the website and/or app, we will inform you accordingly on the processing activities within the legal term.
'''),
              SubHeading('''4.	CHILDREN AND SENSITIVE DATA'''),
              Content('''Our Website and App are not intended for individuals below the age of 16. We do not intentionally collect Personal Information from children below the age of 16.
If you are the parent or legal guardian of a child below the age of 16 and you believe your child has provided us with personal information, please contact us to request the deletion of these personal data. If we confirm that we have collected this kind of personal information, we will delete that information as soon as possible.
We do not collect nor is our intention to collect personal data revealing racial or ethnic origin, political opinions, religious or philosophical beliefs, or trade union membership, genetic data, biometric data for the purpose of uniquely identifying a natural person, data concerning health or data concerning a natural person’s sex life or sexual orientation or personal data relating to criminal convictions and offences or related security measures, excepting the situations expressively regulated by the applicable law.
'''),
              SubHeading('''5.	PERSONAL DATA THAT WE PROCESS, OUR PURPOSES FOR PROCESSING PERSONAL DATA, LEGAL GROUNDS AND RETENTION PERIODS'''),
              Content('''Below you will find information about the purposes for which we Process your Personal Data, the categories of Personal Data we collect for those purposes, the legal grounds on which we carry out the Processing activities and the periods of time we store the Personal Data, in relation to the purposes of the Processing.
Where the lawful basis for the Processing is the Data Subject’s Consent, you may withdraw your consent at any time without constraint and without affecting the lawfulness of the Processing prior to its withdrawal.
'''),
              SubHeading('''•	Purpose: Demo registration – creation of a free account'''),
              Content('''Creation of a free full functional account allows you to add your own people and data and will qualify you as data controller for the processing activities that you carry out. We have no control, and we are not responsible for the processing activities that you perform over the personal data you process within the account.
Personal data categories:  First name, last name, email, language. It is optional to provide us with your photo, middle name, date of birth, gender and mobile phone number.
Depending on your choice, we will also collect and process the name of the church you represent in order to know who is our legal entity client for which the account is created. We have no intention of creating or using data in a way that could be considered as a special category of personal data, or to derive sensitive conclusions from personal data.
Legal ground: Processing of your personal data is based on the contractual relationship between you and us.
Retention period: We generally store your personal data for as long as you are a registered user of our App. Your data will be deleted accordingly within 6 months from the expiry date of the demo account. If you request the deletion of the account, we will delete your data within 48 hours from the receipt of the request. You can find more details about how to delete your account at the following link: https://help.AR DIGITAL SOLUTIONS.com/hc/en-us/articles/7077373105041-Canceling-a-AR DIGITAL SOLUTIONS-Account.
If your data is required for a longer period of time due to legal storage reasons or to establish, exercise or defend a right in court, we store your data in accordance with personal data protection regulations for as long as it is requested by law or is necessary to fulfil the purpose.
Your refusal to provide the personal data necessary for this purpose will prevent us from providing our services.
'''),
              SubHeading('''•	Purpose: Permanent registration – creation of a free or paid account'''),
              Content('''Creation of a free or paid account allows you to add your own people and data and will qualify you as data controller for the processing activities that you carry out. We have no control, and we are not responsible for the processing activities that you perform over the personal data you process within the account.
Personal data categories: Country, province, church name, first name, last name, email, how did you hear about us. It is optional to provide us with your photo, middle name, date of birth, gender, and mobile phone.
If you choose to sign up for any of our paid plans, we will also collect and process payment information and your purchase and order history.
We will also collect and process the name of the church you represent in order to know who is our legal entity client for which the account is created. We have no intention of creating or using data in a way that could be considered as a special category of personal data, or to derive sensitive conclusions from personal data.
Legal ground: Processing of your personal data is based on the contractual relationship between you and us.
Retention period: We generally store your personal data for as long as you are a registered user of our App. If you are inactive for a 6 months period, we will delete your personal data. If you request the deletion of the account, we will delete your data within 48 hours from the receipt of the request. You can find more details about how to delete your account at the following link: https://help.AR DIGITAL SOLUTIONS.com/hc/en-us/articles/7077373105041-Canceling-a-AR DIGITAL SOLUTIONS-Account.
If your data is required for a longer period of time due to legal storage reasons or to establish, exercise or defend a right in court, we store your data in accordance with personal data protection regulations for as long as it is requested by law or is necessary to fulfil the purpose.
Your refusal to provide Personal data necessary for this purpose will prevent us from providing you with our services.
'''),
              SubHeading('''•	Purpose: Ensure functionality and security of our App, perform checks and technical support, prevent and identify frauds'''),
              Content('''Personal data categories: First name, last name, email, IP address and log files.
When using the App, we also collect and process data such as: browser details i.e. name and browser version, the name of the operating system version of the device on which the browser is installed, device identification, system language, your device’s network location data when you sign in (such as country and state), as well as the version of the App you are using. Furthermore, when you login and/or register within the App, we store and process certain data in so-called log files. A log file provides information about the date and time the registration/authentication attempt was made, if it was successful, the e-mail address provided and the IP address.
In addition, we collect and process data related to your interaction with the App, such as the sections visited and the number of clicks and scrolls. Your login details are encrypted, stored and used to log in and to avoid having to sign in again every time you open the App until you sign out of your account.
Legal ground: Processing of your personal data is based on the contractual relationship between you and us, and also considering our legitimate interest to protect your personal data and to monitor and improve the information security of our services.
Retention period: We generally store your personal data for as long as you are a registered user of our App. Your data will be deleted within 6 months from the expiry date of the demo account or if you were inactive for a 6 months period.
If your data is required for a longer period of time due to legal storage reasons or to establish, exercise or defend a right in court, we store your data in accordance with personal data protection regulations for as long as it is requested by law or is necessary to fulfil the purpose.
'''),
              SubHeading('''•	Purpose: Processing, managing and responding to your requests'''),
              Content('''Personal data categories: First name, last name, email, language, any other personal data that you choose to include in the subject and/or description of the request or the attachments to the request, social media profile depending on your choice when editing contact details.
If you contact our customer service through our chat, contact form, by phone or by email, we will use your personal data to process your request.
Legal ground: Processing of your personal data is based on the contractual relationship between you and us, considering our legitimate interest to communicate with you and provide our support in solving your request that arise from using our services, and to maintain and promote your satisfaction.
Retention period: We generally store your personal data for as long as you are a registered user of our App. Your data will be deleted within 6 months from the expiry date of the demo account or from your request to delete the account. If you haven’t registered yet, but you choose to contact us, we will store your personal data for a period of 6 months.
If your data is required for a longer period of time due to legal storage reasons or to establish, exercise or defend a right in court, we store your data in accordance with personal data protection regulations for as long as it is requested by law or is necessary to fulfil the purpose.
'''),
              SubHeading('''•	Purpose: Communicating the latest App updates'''),
              Content('''Personal data categories: First name, email.
Legal ground: Processing of your personal data is performed considering our legitimate interest to inform you about the latest updates regarding our services.
Retention period: We generally store your personal data for as long as you are a registered user of our App. You can opt-out from these communications at any time either through your user account or by clicking the unsubscribe link from the email communication, and we will stop using your personal data for this purpose. If you request the deletion of the account, we will delete your data within 48 hours from the receipt of the request.
If your data is required for a longer period of time due to legal storage reasons or to establish, exercise or defend a right in court, we store your data in accordance with personal data protection regulations for as long as it is requested by law or is necessary to fulfil the purpose.
'''),
              SubHeading('''•	Purpose: Comply with legal obligations such as accounting records, archiving, etc.'''),
              Content('''Personal data categories: First name, last name, church name, role or representation powers, bank account information and any other personal information required by law.
Legal ground: Processing of your personal data is necessary for compliance with a legal obligation.
Retention period: Personal data will be retained according to the applicable legislation in force.
If your data is required for a longer period of time due to legal storage reasons or to establish, exercise or defend a right in court, we store your data in accordance with personal data protection regulations for as long as it is requested by law or is necessary to fulfil the purpose.
'''),
              SubHeading('''•	Purpose: Post a review based on your experience'''),
              Content('''Personal data categories: First name, last name, your image, church name, role or representation powers and other personal data provided by you and contained in the review message.
Legal ground: We rely on your freely expressed consent when you voluntary fill out our review form. You can withdraw your consent at any time, without affecting the legality of the processing based on the consent before its withdrawal.
Retention period: personal data will be stored for as long as we have your consent until withdrawal, in which case data will be deleted. However, we can proceed to the deletion of personal data when we decide that it is no longer relevant for achieving the purpose.
If your data is required for a longer period of time due to legal storage reasons or to establish, exercise or defend a right in court, we store your data in accordance with personal data protection regulations for as long as it is requested by law or is necessary to fulfil the purpose.
'''),
              SubHeading(''' 
5.8 Purpose: Establishing, exercising, or defending a right in proceedings before a court, administrative procedure or other formal proceedings in which we are involved
'''),
              Content('''Personal data categories: First name, last name, church name, role or representation powers, and any other personal information necessary to fulfil the purpose.
Legal ground: Processing of your personal data is performed considering our legitimate interest in defending or exercising our rights and interests and also to comply with a legal obligation to which we are subject.
Retention period: Personal data will be retained according to the applicable legislation in force or until the final settlement of the case.
If your data is required for a longer period of time due to legal storage reasons or to establish, exercise or defend a right in court, we store your data in accordance with personal data protection regulations for as long as it is requested by law or is necessary to fulfil the purpose.
'''),
              Heading('''6.	COOKIES'''),
              Content('''Our Website and App uses cookies, plug-ins and other online identifiers in order to ensure functional browsing or to provide a better browsing experience, to perform statistical analysis on accessing information on the site, or to provide you with custom content and advertising appropriate to your preferences and interests.
Cookies are small text files placed by the visited website or page, through the browser, on the device you use for browsing (computer, smartphone, etc.), which identifies the device when the website or the page is accessed.
Plug-ins are small software applications placed by social media platform providers that integrate them when they are included on the visited website or page.
Online identifiers may be placed by AR DIGITAL SOLUTIONS or by third-parties. In accordance with the permissions you have granted, our partners, third-party websites, will place cookies that will allow you to view the content of these third-party websites on our website and to share the content on the website. The third-parties may collect and use your personal data through their cookies for the purposes they have determined in accordance with their privacy policy. AR DIGITAL SOLUTIONS provides you with the identity information and links to these third-parties, as well as the option to accept or reject their online identifiers.
Personal data may be processed through cookies on the basis of the users’ prior consent, excepting those situations when the cookies and other online identifiers are used for the purpose of transmitting a communication via an electronic communications network or they are necessary in order to provide an information society service, expressly requested by the user. In such case, the processing of personal data is carried out in accordance with the legislation in force on personal data processing and privacy protection in the electronic communications sector on the basis of our legitimate interest of ensuring safe browsing of our website, both for us and for our users, by implementing appropriate technical and organizational measures.
Depending on the cookie type, the categories of personal data processed by cookies may be information about the used device, journal information like IP, searches, browser, browser’s language, hardware settings, date and time of the request, method used to send requests to the server, file capacity obtained in response, and other parameters regarding the user’s operating system.
Detailed information on the cookies our website uses may be found in our Cookie Policy.
How can you change and manage cookies?
Most web browsers allow you to manage cookies. You can choose to accept or reject all cookies, or just specific types of cookies.
The following links provide information on how to modify the cookies settings on some popular browsers:
•	Google Chrome: https://support.google.com/chrome/answer/95647?hl=en
•	Firefox: https://support.mozilla.org/en-US/kb/enable-and-disable-cookies-website-preferences
•	Safari: http://help.apple.com/safari/mac/8.0/#/sfri11471
•	Microsoft Edge: https://support.microsoft.com/en-gb/help/4468242/microsoft-edge-browsing-data-and-privacy-microsoft-privacy
•	Opera: https://help.opera.com/en/latest/security-and-privacy/
'''),
              Heading('''7.	AUTOMATED DECISION MAKING'''),
              Content('''We do not make decisions based solely on automatic data processing of your data including profiling that will have legal effects on you or that will affect you in a similar way to a significant extent.'''),
              Heading('''8.	DISCLOSURE AND TRANSFER OF PERSONAL DATA'''),
              Content('''We may transfer your personal information, to the extent that this is necessary to the following categories of recipients: companies from the same group, service partners, subcontractors, payment providers, archiving companies, IT service providers, software or hardware vendors, market research companies, marketing companies, public authorities, court or arbitral tribunals, as well as competent authorities to investigate criminal offenses.
Personal data may be disclosed or transferred to the categories of recipients mentioned above in order to provide our services at the highest quality level, ensuring the intervention of specialists by outsourcing parts of our business or to provide access to services and benefits according to our business partnerships or to ensure compliance the specific legal obligations to which we are subject according to the activity carried out.
In the event that Personal data is transferred to third countries we will apply the technical and organisational measures required by law and you will be informed about the transfer in accordance with the legal requirements.
'''),
              Heading('''9.	SECURITY OF PERSONAL DATA'''),
              Content('''The security of your Personal Data is important to us. Therefore, we maintain a variety of appropriate technical and organizational measures to protect your Personal Data from loss, misuse, and unauthorized access or disclosure. We limit access to Personal Data to employees who we believe reasonably need to retrieve that information to provide our services. Considering the current state of technology, we have implemented reasonable physical, electronic, and procedural safeguards designed to protect your Personal Data, such as limiting access, encrypting, anonymizing, or storing it on secure media.
Given the technological dynamics and the magnitude of the current threats in the online environment, despite our considerable efforts to ensure the highest possible level of protection of personal data, we cannot always guarantee the absolute effectiveness of the security measures implemented. For this reason, it is very important that you, as the Data subject, know the risks and take minimum measures to protect your Personal data, by thoroughly checking the sources of information, avoiding access to suspicious or unknown links, regular change of passwords and the use of appropriate anti-virus and anti-malware solutions.
'''),
              Heading('''10.	YOUR RIGHTS AND HOW TO EXERCISE THEM'''),
              Content('''Right to be informed: You have the right to be informed regarding the processing of your personal data, as we are doing through this Privacy Policy.
Right of access: You have the right to obtain confirmation whether or not we process your Personal Data, as well as information on the specifics of the processing activities, as well as get access to that Personal data.
Right to rectification: You have the right to obtain from the Controller without undue delay the rectification of inaccurate Personal Data concerning you. Taking into account the purposes of the Processing, you have the right to have incomplete personal data completed, including by means of providing a supplementary statement.
Right to erasure: You have the right to obtain from the Controller the erasure of personal data concerning you without undue delay to the extent that the legal requirements are met. Personal Data will be erased when the legal requirements are met. If you are a registered user of our App, you can find more details about how to delete your account at the following link: https://help.AR DIGITAL SOLUTIONS.com/hc/en-us/articles/7077373105041-Canceling-a-AR DIGITAL SOLUTIONS-Account.
Right to restriction of processing: If the applicable legal provisions are met, you have the right to obtain the restriction of Processing of your Personal Data.
Right to data portability: If the applicable legal provisions are met, you have the right to receive your Personal data which you have provided to us, in a structured, commonly used and machine-readable format and the right to transmit those data to another Controller.
Right to object: In certain situations, such as when we process Personal Data based on legitimate interest, you have the right to object the Processing of your Personal Data. In the event of unjustified opposition, the Controller is entitled to further process your Personal data.
Right to object commercial communication: You may also object to the Processing of your Personal Data for the purpose of sending commercial messages.
Right not to be subject to decisions based solely on automated processing: If the applicable legal provisions are met, you have the right not to be subject to a decision based solely on automatic processing, including profiling, which has legal effects on you or affects you similar to a significant extent.
Right to Opt-Out of Sale or Sharing of Personal Information: You have the right, at any time, to direct a business that sells personal information about the consumer to third parties not to sell the consumer’s personal information.
Right to address to the Supervisory Authority: You have the right to file a complaint with the competent Supervisory Authority on any violation of your rights regarding the processing of your Personal Data.
If you want to contact the Supervisory Authority from your place of residence, another EU Member State, you may find the contact details at https://edpb.europa.eu/about-edpb/about-edpb/members_en#member-ie.
Consent withdrawal: To the extent that we process your Personal data based on your given Consent, you can withdraw your Consent at any time, without affecting the lawfulness of the Processing based on the consent prior to its withdrawal.
Except for the right to contact the Supervisory Authority, which you can exercise using the contact details indicated above, you can exercise your legal rights by contacting our Data Protection Officer in writing at the e-mail _________________
We will respond to your requests without undue delay and in any case within one month of receiving the request. This period may be extended by two months where necessary, taking into account the complexity and number of applications. We will inform you of any such extension within one month of receiving the request, stating the reasons for the delay.
In the event that we do not take action on your request, we will inform you, without delay and no later than one month after receipt of the request, of the reasons for not taking action. In such a case, you have the possibility to lodge a complaint with the competent Supervisory Authority or to take a legal action.
'''),

              Heading('''11.	EUROPEAN UNION REPRESENTATIVE'''),
              Content('''In accordance with Regulation (EU) 2016/679 of the European Parliament and of the Council on the protection of natural persons regarding the processing of personal data and on the free movement of such data (GDPR), AR DIGITAL SOLUTIONS’ designated representative in the European Union is Mr. Alexandru Ganea. If you are based in European Union, you may contact our representative by e-mail at ____________________'''),
              Heading('''12.	UPDATES'''),
              Content('''This Policy is subject to periodic review and updating to ensure that it always corresponds to reality and it is in line with the applicable legal requirements. For this reason, please consult this section regularly to keep up to date with any changes. Any major changes to this Policy will be notified accordingly.'''),
              Heading('''13.	CONTACT'''),
              Content('''If you have any questions or concerns regarding the Processing of your Personal Data, this Privacy Policy or how it applies, or you wish to exercise any of your rights, you can contact our Data Protection Officer using one of the following methods:
•	Email:  sathishkumar@ardigitalsolutions.co
•	 Website form:  Contact Us – AR DIGITAL SOLUTIONS.co
•	Postal address: 59/1,GKM COLONY, MGR NAGAR 30TH STREET JAMBULINGAM MAIN ROAD,KOLATHUR,CHENNAI-600082
•	We thank you for your interest,
AR DIGITAL SOLUTIONS team
 
FacebookTwitterYoutube
 
 
RECENT POSTS
•	Discover new ways to increase church giving
•	How to manage your volunteers
•	How to write and distribute church announcements
•	Signs of bad church leadership to watch out for
•	How to start a church a step-by-step guide
HELP & SUPPORT
•	Sign In
•	Sign Up
•	About us
•	Support
•	Contact Us
•	Terms of Services
•	Privacy Policy
•	Cookie Policy
'''),
            ],
          ),
        ),
      ),
    );
  }

  Heading(String data){
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        data,
        style: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  SubHeading(String data){
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        data,
        style: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Content(String data){
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        data,
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }


}

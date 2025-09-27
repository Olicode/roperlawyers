class PagesController < ApplicationController
  #before_action :set_reviews, except: %i[contact_us]

  def lanzarote
    @mtitle = "Property solicitors Lanzarote, find Lanzarote property lawyers"
    @mdescription = "If you're looking for English-speaking real estate lawyers in Lanzarote, look no further. Contact our property lawyers for legal advice now."
    @reviews = JSON.parse(File.read(File.join('public', 'lanzarote_reviews.json')))
  end

  def lanzarote_conveyancing_lawyer
    @mtitle = "Lanzarote Conveyancing Lawyer | Expert Property Legal Services | Roper Lawyers"
    @mdescription = "Expert conveyancing lawyer in Lanzarote with 15+ years' experience. Bilingual property legal services for UK, Irish & international clients. Free consultation."
    @reviews = JSON.parse(File.read(File.join('public', 'lanzarote_reviews.json')))
  end

  def puerto_del_carmen_property_conveyancing_lawyer
    @mtitle = "Puerto del Carmen Property & Conveyancing Lawyer | Roper Lawyers"
    @mdescription = "Buying or selling property in Puerto del Carmen? Bilingual lawyer with 15+ years' experience. Fast, reliable conveyancing. Free consultation available."
    @reviews = JSON.parse(File.read(File.join('public', 'lanzarote_reviews.json')))
  end

  def tenerife
    @mtitle = "Tenerife estate agents, find property lawyers in Tenerife"
    @mdescription = "If you need advice for buying a property in Tenerife or you're looking to sell your property in Spain, contact our team. We can guide you through the process today."
    @reviews = JSON.parse(File.read(File.join('public','reviews.json')))
  end

  def grancanaria
    @mtitle = "Property lawyers Gran Canaria, find Gran Canaria estate agents"
    @mdescription = "Looking to buy or sell a property in Gran Canaria? Our property lawyers and estate agents in Gran Canaria can guide you through the process. Call today."
    @reviews = JSON.parse(File.read(File.join('public', 'grancanaria_reviews.json')))
  end

  def fuerteventura
    @mtitle = "Property lawyers Fuerteventura, find Fuerteventura estate agents"
    @mdescription = "Fuerteventura is a popular destination to buy, sell, and invest in property. If you need property lawyers in Fuerteventura, call us today."
   @reviews = JSON.parse(File.read(File.join('public', 'fuerteventura_reviews.json')))
  end

  def marbella
    @mtitle = "Property solicitors in Marbella, find Marbella property lawyers"
    @mdescription = "Roper Lawyers are your trusted English-speaking real estate lawyers in Marbella. Find property lawyers providing secure and tailored legal advice now."
    @reviews = JSON.parse(File.read(File.join('public', 'marbella_reviews.json')))
  end

  def madrid
    @mtitle = "Property Conveyancing Solicitors in Madrid"
    @mdescription = "Experienced property lawyers in Madrid are ready to help. Buying or selling a property in Spain and need a solicitor? Enquire, here."
    @reviews = JSON.parse(File.read(File.join('public','reviews.json')))
  end

  def ibiza
    @mtitle = "Property lawyers Ibiza, find property solicitors in Ibiza"
    @mdescription = "Find your dream home in Spain through our property solicitors in Ibiza. Experience expert legal advice from our English-speaking lawyers today."
    @reviews = JSON.parse(File.read(File.join('public','reviews.json')))
  end

  def home
    @mtitle = "Spanish Property Lawyers | Expert Legal Services | Roper Lawyers"
    @mdescription = "Expert Spanish property lawyers with 15+ years' experience. Bilingual legal services for UK, Irish & international clients. Conveyancing, wills, inheritance & VV licenses."
    @reviews = JSON.parse(File.read(File.join('public','reviews.json')))
  end

  def reviews
    @mtitle = "Client Reviews & Testimonials | Roper Lawyers"
    @mdescription = "Read genuine client reviews and testimonials for Roper Lawyers. See why UK, Irish & international clients trust our Spanish property law services."
    @reviews = JSON.parse(File.read(File.join('public','reviews.json')))
  end

  def our_story
    @mtitle = "Our Story – English-Speaking Property Lawyers in Spain | Roper Lawyers"
    @mdescription = "Meet Roper Lawyers: 14+ years helping UK, Irish & European clients with Spanish property law. Bilingual experts in conveyancing, inheritance & wills."
    @reviews = JSON.parse(File.read(File.join('public','reviews.json')))
  end

  def services
    @mtitle = "Legal Services for Spanish Property Law | Roper Lawyers"
    @mdescription = "Comprehensive Spanish property law services: conveyancing, wills, inheritance, holiday rental licenses, NIE numbers & tax advice for non-residents."
    @reviews = JSON.parse(File.read(File.join('public','reviews.json')))
  end

  def property_buying_guide
    @mtitle = "How to Buy Property in Spain: A Complete Guide for Expats | Roper Lawyers"
    @mdescription = "Complete step-by-step guide for UK, Irish & European expats buying property in Spain. NIE numbers, legal checks, costs, taxes & common pitfalls explained."
    @reviews = JSON.parse(File.read(File.join('public','reviews.json')))
  end

  def holiday_rental_rules_2025
    @mtitle = "VV Licenses & Holiday Rental Rules 2025: Canary Islands Complete Guide | Roper Lawyers"
    @mdescription = "Complete guide to VV licenses and new 2025 holiday rental regulations in the Canary Islands. Legal requirements, community approval, tax obligations & compliance."
    @reviews = JSON.parse(File.read(File.join('public','reviews.json')))
  end

  def blog
    @mtitle = "Legal News & Insights | Spanish Property Law Blog | Roper Lawyers"
    @mdescription = "Stay updated with the latest Spanish property law news, legal insights, and expert guidance from Roper Lawyers. Holiday rental regulations, property buying guides & more."
    @reviews = JSON.parse(File.read(File.join('public','reviews.json')))
  end

  def contact_us
    TransactionalMailer.contact_us(ENV['MAILER_TO'] || "rcvdtest@yopmail.com", params[:email],params[:url], params[:message]).deliver!
    render json: { success: true }
  end

  def buying_property
    @mtitle = "Buying Property in Spain | Expert Legal Guidance | Roper Lawyers"
    @mdescription = "Expert legal guidance for buying property in Spain. English-speaking lawyers with 15+ years' experience. Secure conveyancing services. Free consultation."
    @reviews = JSON.parse(File.read(File.join('public','reviews.json')))
  end

  def selling_property
    @mtitle = "Selling Property in Spain | Expert Legal Services | Roper Lawyers"
    @mdescription = "Expert legal services for selling property in Spain. Bilingual lawyers ensuring smooth transactions. Tax advice and conveyancing support. Free consultation."
    @reviews = JSON.parse(File.read(File.join('public','reviews.json')))
  end

  def wills
    @mtitle = "Spanish Wills & Testament Services | Expert Legal Advice | Roper Lawyers"
    @mdescription = "Expert Spanish will and testament services. Bilingual lawyers ensuring your assets are protected. International will advice. Free consultation available."
    @reviews = JSON.parse(File.read(File.join('public','reviews.json')))
  end

  def inheritance
    @mtitle = "Spanish Inheritance Law | Expert Legal Guidance | Roper Lawyers"
    @mdescription = "Expert guidance on Spanish inheritance law. Bilingual lawyers helping with probate, succession planning, and inheritance tax. Free consultation available."
    @reviews = JSON.parse(File.read(File.join('public','reviews.json')))
  end

  def new_build_registration
    @mtitle = "New Build Registration Spain | Expert Legal Services | Roper Lawyers"
    @mdescription = "Expert new build registration services in Spain. Bilingual lawyers handling declarations, permits, and legal compliance. Free consultation available."
    @reviews = JSON.parse(File.read(File.join('public','reviews.json')))
  end

  def holiday_rental_license
    @mtitle = "Holiday Rental License Spain | VV License Experts | Roper Lawyers"
    @mdescription = "Expert holiday rental licensing in Spain. VV license applications, compliance, and legal support. Bilingual lawyers with 15+ years' experience."
    @reviews = JSON.parse(File.read(File.join('public','reviews.json')))
  end

  # Lanzarote-specific pages
  def buying_property_lanzarote
    @mtitle = "Buying Property in Lanzarote | Expert Legal Guidance | Roper Lawyers"
    @mdescription = "Expert legal guidance for buying property in Lanzarote. English-speaking lawyers with 15+ years' experience. Secure conveyancing services."
    @reviews = JSON.parse(File.read(File.join('public', 'lanzarote_reviews.json')))
  end

  def selling_property_lanzarote
    @mtitle = "Selling Property in Lanzarote | Expert Legal Services | Roper Lawyers"
    @mdescription = "Expert legal services for selling property in Lanzarote. Bilingual lawyers ensuring smooth transactions. Tax advice and conveyancing support."
    @reviews = JSON.parse(File.read(File.join('public', 'lanzarote_reviews.json')))
  end

  def wills_lanzarote
    @mtitle = "Lanzarote Wills & Testament Services | Expert Legal Advice | Roper Lawyers"
    @mdescription = "Expert Spanish will and testament services in Lanzarote. Bilingual lawyers ensuring your assets are protected. Free consultation available."
    @reviews = JSON.parse(File.read(File.join('public', 'lanzarote_reviews.json')))
  end

  def inheritance_lanzarote
    @mtitle = "Lanzarote Inheritance Law | Expert Legal Guidance | Roper Lawyers"
    @mdescription = "Expert guidance on Spanish inheritance law in Lanzarote. Bilingual lawyers helping with probate, succession planning, and inheritance tax."
    @reviews = JSON.parse(File.read(File.join('public', 'lanzarote_reviews.json')))
  end

  def new_build_registration_lanzarote
    @mtitle = "New Build Registration Lanzarote | Expert Legal Services | Roper Lawyers"
    @mdescription = "Expert new build registration services in Lanzarote. Bilingual lawyers handling declarations, permits, and legal compliance."
    @reviews = JSON.parse(File.read(File.join('public', 'lanzarote_reviews.json')))
  end

  def holiday_rental_license_lanzarote
    @mtitle = "Holiday Rental License Lanzarote | VV License Experts | Roper Lawyers"
    @mdescription = "Expert holiday rental licensing in Lanzarote. VV license applications, compliance, and legal support. Bilingual lawyers with 15+ years' experience."
    @reviews = JSON.parse(File.read(File.join('public', 'lanzarote_reviews.json')))
  end

  # Puerto del Carmen pages
  def buying_property_lanzarote_puerto_del_carmen
    @mtitle = "Buying Property Puerto del Carmen | Expert Legal Guidance | Roper Lawyers"
    @mdescription = "Expert legal guidance for buying property in Puerto del Carmen, Lanzarote. English-speaking lawyers with 15+ years' experience."
    @reviews = JSON.parse(File.read(File.join('public', 'lanzarote_reviews.json')))
  end

  def selling_property_lanzarote_puerto_del_carmen
    @mtitle = "Selling Property Puerto del Carmen | Expert Legal Services | Roper Lawyers"
    @mdescription = "Expert legal services for selling property in Puerto del Carmen, Lanzarote. Bilingual lawyers ensuring smooth transactions."
    @reviews = JSON.parse(File.read(File.join('public', 'lanzarote_reviews.json')))
  end

  def wills_lanzarote_puerto_del_carmen
    @mtitle = "Puerto del Carmen Wills & Testament | Expert Legal Advice | Roper Lawyers"
    @mdescription = "Expert Spanish will and testament services in Puerto del Carmen, Lanzarote. Bilingual lawyers ensuring your assets are protected."
    @reviews = JSON.parse(File.read(File.join('public', 'lanzarote_reviews.json')))
  end

  def inheritance_lanzarote_puerto_del_carmen
    @mtitle = "Puerto del Carmen Inheritance Law | Expert Legal Guidance | Roper Lawyers"
    @mdescription = "Expert guidance on Spanish inheritance law in Puerto del Carmen, Lanzarote. Bilingual lawyers helping with probate and succession."
    @reviews = JSON.parse(File.read(File.join('public', 'lanzarote_reviews.json')))
  end

  def new_build_registration_lanzarote_puerto_del_carmen
    @mtitle = "New Build Registration Puerto del Carmen | Expert Legal Services | Roper Lawyers"
    @mdescription = "Expert new build registration services in Puerto del Carmen, Lanzarote. Bilingual lawyers handling declarations and permits."
    @reviews = JSON.parse(File.read(File.join('public', 'lanzarote_reviews.json')))
  end

  def holiday_rental_license_lanzarote_puerto_del_carmen
    @mtitle = "Holiday Rental License Puerto del Carmen | VV License Experts | Roper Lawyers"
    @mdescription = "Expert holiday rental licensing in Puerto del Carmen, Lanzarote. VV license applications and compliance support."
    @reviews = JSON.parse(File.read(File.join('public', 'lanzarote_reviews.json')))
  end

  # Playa Blanca pages
  def buying_property_lanzarote_playa_blanca
    @mtitle = "Buying Property Playa Blanca | Expert Legal Guidance | Roper Lawyers"
    @mdescription = "Expert legal guidance for buying property in Playa Blanca, Lanzarote. English-speaking lawyers with 15+ years' experience."
    @reviews = JSON.parse(File.read(File.join('public', 'lanzarote_reviews.json')))
  end

  def selling_property_lanzarote_playa_blanca
    @mtitle = "Selling Property Playa Blanca | Expert Legal Services | Roper Lawyers"
    @mdescription = "Expert legal services for selling property in Playa Blanca, Lanzarote. Bilingual lawyers ensuring smooth transactions."
    @reviews = JSON.parse(File.read(File.join('public', 'lanzarote_reviews.json')))
  end

  def wills_lanzarote_playa_blanca
    @mtitle = "Playa Blanca Wills & Testament | Expert Legal Advice | Roper Lawyers"
    @mdescription = "Expert Spanish will and testament services in Playa Blanca, Lanzarote. Bilingual lawyers ensuring your assets are protected."
    @reviews = JSON.parse(File.read(File.join('public', 'lanzarote_reviews.json')))
  end

  def inheritance_lanzarote_playa_blanca
    @mtitle = "Playa Blanca Inheritance Law | Expert Legal Guidance | Roper Lawyers"
    @mdescription = "Expert guidance on Spanish inheritance law in Playa Blanca, Lanzarote. Bilingual lawyers helping with probate and succession."
    @reviews = JSON.parse(File.read(File.join('public', 'lanzarote_reviews.json')))
  end

  def new_build_registration_lanzarote_playa_blanca
    @mtitle = "New Build Registration Playa Blanca | Expert Legal Services | Roper Lawyers"
    @mdescription = "Expert new build registration services in Playa Blanca, Lanzarote. Bilingual lawyers handling declarations and permits."
    @reviews = JSON.parse(File.read(File.join('public', 'lanzarote_reviews.json')))
  end

  def holiday_rental_license_lanzarote_playa_blanca
    @mtitle = "Holiday Rental License Playa Blanca | VV License Experts | Roper Lawyers"
    @mdescription = "Expert holiday rental licensing in Playa Blanca, Lanzarote. VV license applications and compliance support."
    @reviews = JSON.parse(File.read(File.join('public', 'lanzarote_reviews.json')))
  end

  # Costa Teguise pages
  def buying_property_lanzarote_costa_teguise
    @mtitle = "Buying Property Costa Teguise | Expert Legal Guidance | Roper Lawyers"
    @mdescription = "Expert legal guidance for buying property in Costa Teguise, Lanzarote. English-speaking lawyers with 15+ years' experience."
    @reviews = JSON.parse(File.read(File.join('public', 'lanzarote_reviews.json')))
  end

  def selling_property_lanzarote_costa_teguise
    @mtitle = "Selling Property Costa Teguise | Expert Legal Services | Roper Lawyers"
    @mdescription = "Expert legal services for selling property in Costa Teguise, Lanzarote. Bilingual lawyers ensuring smooth transactions."
    @reviews = JSON.parse(File.read(File.join('public', 'lanzarote_reviews.json')))
  end

  def wills_lanzarote_costa_teguise
    @mtitle = "Costa Teguise Wills & Testament | Expert Legal Advice | Roper Lawyers"
    @mdescription = "Expert Spanish will and testament services in Costa Teguise, Lanzarote. Bilingual lawyers ensuring your assets are protected."
    @reviews = JSON.parse(File.read(File.join('public', 'lanzarote_reviews.json')))
  end

  def inheritance_lanzarote_costa_teguise
    @mtitle = "Costa Teguise Inheritance Law | Expert Legal Guidance | Roper Lawyers"
    @mdescription = "Expert guidance on Spanish inheritance law in Costa Teguise, Lanzarote. Bilingual lawyers helping with probate and succession."
    @reviews = JSON.parse(File.read(File.join('public', 'lanzarote_reviews.json')))
  end

  def new_build_registration_lanzarote_costa_teguise
    @mtitle = "New Build Registration Costa Teguise | Expert Legal Services | Roper Lawyers"
    @mdescription = "Expert new build registration services in Costa Teguise, Lanzarote. Bilingual lawyers handling declarations and permits."
    @reviews = JSON.parse(File.read(File.join('public', 'lanzarote_reviews.json')))
  end

  def holiday_rental_license_lanzarote_costa_teguise
    @mtitle = "Holiday Rental License Costa Teguise | VV License Experts | Roper Lawyers"
    @mdescription = "Expert holiday rental licensing in Costa Teguise, Lanzarote. VV license applications and compliance support."
    @reviews = JSON.parse(File.read(File.join('public', 'lanzarote_reviews.json')))
  end

  def thank_you
    @mtitle = "Thank You | Roper Lawyers"
    @mdescription = "Thank you for contacting Roper Lawyers. We will get back to you soon."
  end

  def step2_contact
    @mtitle = "Complete Your Legal Inquiry | Step 2 Contact Form | Roper Lawyers"
    @mdescription = "Complete your legal inquiry with detailed information. Step 2 of our consultation process for personalized Spanish property law guidance."
    # Get parameters from Salesforce redirect (if any)
    @first_name = params[:first_name] || session[:contact_first_name]
    @last_name = params[:last_name] || session[:contact_last_name]
    @email = params[:email] || session[:contact_email]
    
    # Store in session for form pre-population
    session[:contact_first_name] = @first_name
    session[:contact_last_name] = @last_name
    session[:contact_email] = @email
  end

  # Team pages
  def team
    @mtitle = "Meet the Team | Expert Spanish Property Lawyers | Roper Lawyers"
    @mdescription = "Meet our expert team of bilingual Spanish property lawyers. Led by Olivier Roper, with 15+ years' experience helping international clients."
  end

  def team_olivier_roper
    @mtitle = "Olivier Roper | Founding Partner & Lead Property Lawyer | Roper Lawyers"
    @mdescription = "Olivier Roper, bilingual Spanish property lawyer with 15+ years' experience. Expert in conveyancing, inheritance law, and Spanish legal systems."
  end

  def team_rachel_jane_buckett
    @mtitle = "Rachel Jane Buckett | Senior Legal Assistant | Roper Lawyers"
    @mdescription = "Rachel Jane Buckett, experienced legal assistant specializing in Spanish property transactions and client support at Roper Lawyers."
  end

  def why_choose_us
    @mtitle = "Why Choose Roper Lawyers | Expert Spanish Property Law Specialists"
    @mdescription = "Discover why Roper Lawyers is the trusted choice for Spanish property law. 14+ years experience, bilingual service, transparent pricing, and proven success for international clients."
  end

  # Missing controller actions
  def spain_property_guide
    @mtitle = "Complete Spain Property Guide | Buying & Selling Guide | Roper Lawyers"
    @mdescription = "Comprehensive guide to Spanish property law. Expert advice on buying, selling, legal requirements, taxes, and procedures. Free legal consultation available."
    @reviews = JSON.parse(File.read(File.join('public','reviews.json')))
  end

  def free_consultation
    @mtitle = "Free Legal Consultation | Spanish Property Law | Roper Lawyers"
    @mdescription = "Book your free consultation with expert Spanish property lawyers. Get personalized legal advice for buying, selling, wills, inheritance, and VV licenses."
    @reviews = JSON.parse(File.read(File.join('public','reviews.json')))
  end

  def consultation
    @mtitle = "Legal Consultation Services | Spanish Property Law | Roper Lawyers"
    @mdescription = "Professional legal consultation services for Spanish property law. Expert advice on conveyancing, inheritance, wills, and holiday rental licenses."
    @reviews = JSON.parse(File.read(File.join('public','reviews.json')))
  end

  def vv_license
    @mtitle = "VV License Services | Holiday Rental Licensing | Roper Lawyers"
    @mdescription = "Expert VV license services for holiday rental properties in Spain. Complete licensing support, compliance guidance, and legal assistance."
    @reviews = JSON.parse(File.read(File.join('public','reviews.json')))
  end

  def privacy_policy
    @mtitle = "Privacy Policy | Data Protection | Roper Lawyers"
    @mdescription = "Privacy policy and data protection information for Roper Lawyers. How we collect, use, and protect your personal information."
  end

  def cookies_policy
    @mtitle = "Cookies Policy | Website Usage Information | Roper Lawyers"
    @mdescription = "Cookies policy for Roper Lawyers website. Information about how we use cookies and similar technologies to improve your browsing experience."
  end

  def contact
    @mtitle = "Contact Us | Schedule a Consultation | Roper Lawyers"
    @mdescription = "Contact Roper Lawyers for expert Spanish property law advice. Schedule a free consultation with our bilingual legal team. Multiple ways to get in touch."
    @reviews = JSON.parse(File.read(File.join('public','reviews.json')))
  end
end


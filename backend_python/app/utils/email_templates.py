from typing import Dict

def get_verification_email_template(otp: str, user_name: str, lang: str = "en") -> Dict[str, str]:
    """Generate verification email HTML template"""
    
    if lang == "ar":
        subject = "تأكيد حسابك في Swim360"
        body = f"""
        <html dir="rtl">
            <body style="font-family: 'Cairo', Arial, sans-serif; background: #f5f5f5; padding: 20px;">
                <div style="max-width: 600px; margin: 0 auto; background: white; padding: 30px; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1);">
                    <div style="text-align: center; margin-bottom: 30px;">
                        <h1 style="color: #0077BE; margin: 0;">Swim360</h1>
                        <p style="color: #666; margin: 5px 0;">دائرة العافية الكاملة</p>
                    </div>
                    
                    <h2 style="color: #2C3E50;">مرحباً {user_name}!</h2>
                    <p style="color: #666; line-height: 1.6;">شكراً لتسجيلك في Swim360. رمز التحقق الخاص بك هو:</p>
                    
                    <div style="background: linear-gradient(135deg, #0077BE 0%, #00B4D8 100%); padding: 25px; text-align: center; border-radius: 10px; margin: 30px 0;">
                        <div style="background: white; display: inline-block; padding: 15px 40px; border-radius: 5px;">
                            <span style="font-size: 32px; font-weight: bold; color: #0077BE; letter-spacing: 8px;">{otp}</span>
                        </div>
                    </div>
                    
                    <p style="color: #666; line-height: 1.6;">هذا الرمز صالح لمدة 5 دقائق فقط.</p>
                    
                    <div style="background: #FFF3CD; border-right: 4px solid #FFD166; padding: 15px; border-radius: 5px; margin: 20px 0;">
                        <p style="color: #856404; margin: 0;">⚠️ لا تشارك هذا الرمز مع أي شخص</p>
                    </div>
                    
                    <hr style="border: none; border-top: 1px solid #eee; margin: 30px 0;">
                    
                    <p style="color: #999; font-size: 12px; text-align: center;">
                        إذا لم تطلب هذا، يرجى تجاهل هذا البريد الإلكتروني.
                    </p>
                </div>
            </body>
        </html>
        """
    else:
        subject = "Verify your Swim360 account"
        body = f"""
        <html>
            <body style="font-family: 'Inter', Arial, sans-serif; background: #f5f5f5; padding: 20px;">
                <div style="max-width: 600px; margin: 0 auto; background: white; padding: 30px; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1);">
                    <div style="text-align: center; margin-bottom: 30px;">
                        <h1 style="color: #0077BE; margin: 0;">Swim360</h1>
                        <p style="color: #666; margin: 5px 0;">Your Complete Wellness Circle</p>
                    </div>
                    
                    <h2 style="color: #2C3E50;">Welcome {user_name}!</h2>
                    <p style="color: #666; line-height: 1.6;">Thanks for signing up with Swim360. Your verification code is:</p>
                    
                    <div style="background: linear-gradient(135deg, #0077BE 0%, #00B4D8 100%); padding: 25px; text-align: center; border-radius: 10px; margin: 30px 0;">
                        <div style="background: white; display: inline-block; padding: 15px 40px; border-radius: 5px;">
                            <span style="font-size: 32px; font-weight: bold; color: #0077BE; letter-spacing: 8px;">{otp}</span>
                        </div>
                    </div>
                    
                    <p style="color: #666; line-height: 1.6;">This code is valid for 5 minutes only.</p>
                    
                    <div style="background: #FFF3CD; border-left: 4px solid #FFD166; padding: 15px; border-radius: 5px; margin: 20px 0;">
                        <p style="color: #856404; margin: 0;">⚠️ Don't share this code with anyone</p>
                    </div>
                    
                    <hr style="border: none; border-top: 1px solid #eee; margin: 30px 0;">
                    
                    <p style="color: #999; font-size: 12px; text-align: center;">
                        If you didn't request this, please ignore this email.
                    </p>
                </div>
            </body>
        </html>
        """
    
    return {
        "subject": subject,
        "body": body
    }

def get_welcome_email_template(user_name: str, lang: str = "en") -> Dict[str, str]:
    """Generate welcome email after successful verification"""
    
    if lang == "ar":
        subject = "مرحباً بك في Swim360! 🏊‍♂️"
        body = f"""
        <html dir="rtl">
            <body style="font-family: 'Cairo', Arial, sans-serif;">
                <h1>أهلاً بك، {user_name}!</h1>
                <p>تم تفعيل حسابك بنجاح.</p>
                <h2>يمكنك الآن:</h2>
                <ul>
                    <li>استعراض خدمات السباحة واللياقة البدنية</li>
                    <li>التسوق في السوق الإلكتروني</li>
                    <li>التسجيل كمقدم خدمة</li>
                    <li>التواصل مع المدربين</li>
                </ul>
            </body>
        </html>
        """
    else:
        subject = "Welcome to Swim360! 🏊‍♂️"
        body = f"""
        <html>
            <body style="font-family: 'Inter', Arial, sans-serif;">
                <h1>Welcome aboard, {user_name}!</h1>
                <p>Your account has been successfully verified.</p>
                <h2>You can now:</h2>
                <ul>
                    <li>Browse swimming and fitness services</li>
                    <li>Shop in our marketplace</li>
                    <li>Enroll as a service provider</li>
                    <li>Connect with coaches</li>
                </ul>
            </body>
        </html>
        """
    
    return {
        "subject": subject,
        "body": body
    }
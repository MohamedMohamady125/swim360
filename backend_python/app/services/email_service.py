from sendgrid import SendGridAPIClient
from sendgrid.helpers.mail import Mail, Email, To, Content
from app.core.config import settings
from app.utils.email_templates import (
    get_verification_email_template,
    get_welcome_email_template
)
import logging
from typing import Optional

logger = logging.getLogger(__name__)

class EmailService:
    def __init__(self):
        self.client = SendGridAPIClient(settings.sendgrid_api_key) if settings.sendgrid_api_key else None
        self.from_email = Email(settings.from_email, settings.from_name)
    
    async def send_verification_email(self, email: str, otp: str, user_name: str, lang: str = "en") -> bool:
        """Send OTP verification email"""
        try:
            if not self.client:
                logger.warning("SendGrid not configured, skipping email")
                print(f"VERIFICATION CODE FOR {email}: {otp}")  # For development
                return True
            
            template = get_verification_email_template(otp, user_name, lang)
            
            message = Mail(
                from_email=self.from_email,
                to_emails=To(email),
                subject=template["subject"],
                html_content=Content("text/html", template["body"])
            )
            
            response = self.client.send(message)
            
            if response.status_code in [200, 201, 202]:
                logger.info(f"Verification email sent to {email}")
                return True
            else:
                logger.error(f"Failed to send email: {response.status_code}")
                return False
                
        except Exception as e:
            logger.error(f"Email sending error: {str(e)}")
            # In development, print OTP to console
            if settings.debug:
                print(f"VERIFICATION CODE FOR {email}: {otp}")
            return False
    
    async def send_welcome_email(self, email: str, user_name: str, lang: str = "en") -> bool:
        """Send welcome email after verification"""
        try:
            if not self.client:
                logger.warning("SendGrid not configured, skipping email")
                return True
            
            template = get_welcome_email_template(user_name, lang)
            
            message = Mail(
                from_email=self.from_email,
                to_emails=To(email),
                subject=template["subject"],
                html_content=Content("text/html", template["body"])
            )
            
            response = self.client.send(message)
            
            if response.status_code in [200, 201, 202]:
                logger.info(f"Welcome email sent to {email}")
                return True
            else:
                logger.error(f"Failed to send welcome email: {response.status_code}")
                return False
                
        except Exception as e:
            logger.error(f"Welcome email error: {str(e)}")
            return False
    
    async def send_password_reset_email(self, email: str, reset_token: str, user_name: str) -> bool:
        """Send password reset email"""
        try:
            reset_link = f"{settings.frontend_url}/reset-password?token={reset_token}"
            
            subject = "Reset your Swim360 password"
            body = f"""
            <html>
                <body>
                    <h2>Password Reset Request</h2>
                    <p>Hi {user_name},</p>
                    <p>Click the link below to reset your password:</p>
                    <a href="{reset_link}" style="background: #0077BE; color: white; padding: 10px 20px; text-decoration: none; border-radius: 5px;">
                        Reset Password
                    </a>
                    <p>This link expires in 1 hour.</p>
                    <p>If you didn't request this, please ignore this email.</p>
                </body>
            </html>
            """
            
            message = Mail(
                from_email=self.from_email,
                to_emails=To(email),
                subject=subject,
                html_content=Content("text/html", body)
            )
            
            if self.client:
                response = self.client.send(message)
                return response.status_code in [200, 201, 202]
            else:
                logger.warning(f"Password reset link for {email}: {reset_link}")
                return True
                
        except Exception as e:
            logger.error(f"Password reset email error: {str(e)}")
            return False
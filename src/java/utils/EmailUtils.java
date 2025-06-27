package utils;

import jakarta.mail.*;
import jakarta.mail.internet.*;
import java.util.Properties;

public class EmailUtils {

    // Thay bằng email và App password của bạn (App Password của Gmail)
    private static final String FROM_EMAIL = "he182125vuduchieu@gmail.com";
    private static final String APP_PASSWORD = "qemp xmfc zdev lkqa";

    /**
     * Hàm gửi email HTML
     * @param to: email người nhận
     * @param subject: tiêu đề
     * @param content: nội dung HTML
     * @return true nếu gửi thành công, false nếu lỗi
     */
    public static boolean sendEmail(String to, String subject, String content) {
        try {
            // Cấu hình SMTP
            Properties props = new Properties();
            props.put("mail.smtp.host", "smtp.gmail.com");
            props.put("mail.smtp.port", "587");
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.starttls.enable", "true");

            // Tạo Session
            Session session = Session.getInstance(props, new Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(FROM_EMAIL, APP_PASSWORD);
                }
            });

            // Tạo message
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(FROM_EMAIL, "Shop Online")); // Tên người gửi
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
            message.setSubject(MimeUtility.encodeText(subject, "UTF-8", "B"));
            message.setContent(content, "text/html; charset=UTF-8");

            // Gửi email
            Transport.send(message);

            System.out.println("✅ Email đã được gửi tới: " + to);
            return true;

        } catch (Exception e) {
            System.err.println("❌ Lỗi gửi email tới: " + to + " - " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

}

CREATE TABLE colfusion_notifications(
	ntf_id INT(20) NOT NULL AUTO_INCREMENT PRIMARY KEY,
	sender_id INT(20),
	target_id INT(11),
    action VARCHAR(100) NOT NULL,
    FOREIGN KEY (sender_id) REFERENCES colfusion_users(user_id)
    )

CREATE TABLE colfusion_notifications_unread(
	ntf_id INT(20) NOT NULL,
	receiver_id INT(20),
	FOREIGN KEY (ntf_id) REFERENCES colfusion_notifications(ntf_id)
	)

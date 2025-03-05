<?php

require '../vendor/phpmailer/phpmailer/src/Exception.php';
require '../vendor/phpmailer/phpmailer/src/PHPMailer.php';
require '../vendor/phpmailer/phpmailer/src/SMTP.php';

use PHPMailer\PHPMailer\Exception;
use PHPMailer\PHPMailer\PHPMailer;

$mail = new PHPMailer(true);

try {
    $dataDecoded = '';
    if ($_SERVER['REQUEST_METHOD'] === 'POST') {
        $mail->isSMTP();
        $mail->Host = 'mailcatcher';
        $mail->Port = 1025;

        $mail->setFrom('client-request@gmail.com', 'Client request');
        $mail->addReplyTo('client-request@gmail.com', 'Client request');
        $mail->addAddress('fitness-app@gmail.com', 'Fitness app');

        $mail->isHTML(true);
        $mail->Subject = 'New Contact Form Request';


        $data = file_get_contents('php://input');
        $dataDecoded = json_decode($data, true);
    }

    $emailTemplateVar['receiver'] = '';
    ob_start();
    include('../templates/email-template.php');
    $bodyHtml = ob_get_contents();
    ob_end_clean();
    $mail->Body = $bodyHtml;
    foreach ($dataDecoded as $key => $value) {
        $mail->Body .= '<div>' . $key . ': ' . $value . '</div>';
    };

    if ($mail->send()) {
//        http_response_code(500);
        $jsonResponse = json_encode(['message' => 'Something went wrong when submitting the form']);
        $jsonResponse = json_encode(['success' => true, 'message' => 'The form was submitted successfully']);
    } else {
        http_response_code(500);
        $jsonResponse = json_encode(['message' => $mail->ErrorInfo]);
    }
    header('Content-Type: application/json');
    echo $jsonResponse;
} catch (Exception $e) {
    http_response_code(500);
    $jsonResponse = json_encode(['message' => $mail->ErrorInfo]);
    header('Content-Type: application/json');
    echo $jsonResponse;
}

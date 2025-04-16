package com.smhrd.web;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.Date;
import java.util.UUID;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;
import com.amazonaws.HttpMethod;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.model.*;
import javax.imageio.IIOImage;
import javax.imageio.ImageIO;
import javax.imageio.ImageWriteParam;
import javax.imageio.ImageWriter;
import javax.imageio.stream.ImageOutputStream;
import java.awt.Graphics2D;
import java.awt.image.BufferedImage;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.InputStream;

@Component
@ComponentScan(basePackages = "com.smhrd.config") 
public class S3Uploader {

    private final AmazonS3 amazonS3;

    @Value("${cloud.aws.s3.bucket}")
    private String bucket;
    
    @Value("${cloud.aws.s3.board-images-dir}")
    private String boardImagesDir;
    
    public S3Uploader(AmazonS3 amazonS3) {
        this.amazonS3 = amazonS3;
    }

    // 파일 업로드 메소드
    public String upload(MultipartFile file) throws IOException {
    	

//    	long originalSize = file.getSize(); // 바이트 단위
//    	System.out.println("압축 전 용량: " + originalSize + " bytes");
    	
    	InputStream compressedInputStream = compressImage(file, 0.3f);

    	// 압축 후 용량 계산
//    	int compressedSize = compressedInputStream.available(); // 바이트 단위
//    	System.out.println("압축 후 용량: " + compressedSize + " bytes");
    	
    	ObjectMetadata metadata = new ObjectMetadata();
    	metadata.setContentLength(compressedInputStream.available());
    	metadata.setContentType("image/jpeg");

    	String dirName = "board_images";
    	String fileName = UUID.randomUUID().toString() + "_" +
    	                  URLEncoder.encode(file.getOriginalFilename(), StandardCharsets.UTF_8.name());
    	String filePath = dirName + "/" + fileName;

    	amazonS3.putObject(new PutObjectRequest(bucket, filePath, compressedInputStream, metadata));

    	return filePath;
    }


    // 파일 접근링크 불러오는 메소드
    public String generatePresignedUrl(String filePath) {
//    	System.out.println("filePath : " + filePath);
    	
    	int expireSeconds = 15;
    	
        Date expiration = new Date();
        expiration.setTime(expiration.getTime() + (expireSeconds * 1000));

        GeneratePresignedUrlRequest request = new GeneratePresignedUrlRequest(bucket, filePath)
                .withMethod(HttpMethod.GET)
                .withExpiration(expiration);
        
        return amazonS3.generatePresignedUrl(request).toString();
    }

    // 파일 삭제 메소드
    public void deleteFile(String filePath) {
        try {
            amazonS3.deleteObject(new DeleteObjectRequest(bucket, filePath));
//            System.out.println("파일 삭제 완료 : " + filePath);
        } catch (Exception e) {
            System.err.println("파일 삭제 실패... : " + e.getMessage());
        }
    }
    
    //이미지 열화
    public InputStream compressImage(MultipartFile file, float quality) throws IOException {
        // MultipartFile → BufferedImage
        BufferedImage originalImage = ImageIO.read(file.getInputStream());

        if (originalImage == null) {
            throw new IOException("이미지 파일이 아님: " + file.getOriginalFilename());
        }

        // 색공간 RGB로 변환 (Bogus colorspace 방지)
        BufferedImage rgbImage = new BufferedImage(
            originalImage.getWidth(),
            originalImage.getHeight(),
            BufferedImage.TYPE_INT_RGB
        );
        Graphics2D graphics = rgbImage.createGraphics();
        graphics.drawImage(originalImage, 0, 0, null);
        graphics.dispose();

        // 압축 품질 설정
        ByteArrayOutputStream os = new ByteArrayOutputStream();
        ImageWriter writer = ImageIO.getImageWritersByFormatName("jpg").next();
        ImageOutputStream ios = ImageIO.createImageOutputStream(os);
        writer.setOutput(ios);

        ImageWriteParam param = writer.getDefaultWriteParam();
        if (param.canWriteCompressed()) {
            param.setCompressionMode(ImageWriteParam.MODE_EXPLICIT);
            param.setCompressionQuality(quality); // 예: 0.5f
        }

        writer.write(null, new IIOImage(rgbImage, null, null), param);
        writer.dispose();
        ios.close();

        return new ByteArrayInputStream(os.toByteArray());
    }



}

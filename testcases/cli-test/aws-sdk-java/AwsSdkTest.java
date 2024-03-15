import com.amazonaws.AmazonClientException;
import com.amazonaws.AmazonServiceException;
import com.amazonaws.auth.AWSCredentials;
import com.amazonaws.auth.AWSCredentialsProvider;
import com.amazonaws.services.kms.AWSKMS;
import com.amazonaws.services.kms.AWSKMSClient;
import com.amazonaws.services.kms.model.DescribeKeyRequest;
import com.amazonaws.services.kms.model.DescribeKeyResult;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3Client;
import com.amazonaws.services.s3.model.Bucket;
import java.nio.ByteBuffer;
public class AwsSdkTest{
public static void main(String[] args) {
final String USAGE = "\n" +
"To run this example, supply the name of a bucket to create!\n" +
"Ex: ListBuckets <unique-bucket-name>\n";
if (args.length < 1) {
System.out.println(USAGE);
System.exit(1);
}
String bucket_name = args[0];
System.out.println("Creating S3 bucket: " + bucket_name);
final AmazonS3 s3 = new AmazonS3Client();
try {
Bucket b = s3.createBucket(bucket_name);
} catch (AmazonServiceException e) {
System.err.println(e.getErrorMessage());
}
System.out.println("Finish S3 test!");
listAllCustomerMasterKeys("arn:aws:kms:us-west-2:144446676909:key/96a3a735-b8f5-4456-9488-ecbeb4087540");
System.out.println("Finish kms test!");
}
private static void listAllCustomerMasterKeys(String masterKeyArn) {
AWSKMS kmsClient = new AWSKMSClient();
DescribeKeyRequest req = new DescribeKeyRequest().withKeyId(masterKeyArn);
try {
DescribeKeyResult res = kmsClient.describeKey(req);
System.out.println(res);
} catch (AmazonClientException e) {
System.err.println("describeKey failed: " + e);
}
}
}
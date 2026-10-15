#include <aws/core/Aws.h>
#include <aws/core/client/ClientConfiguration.h>
#include <aws/core/auth/AWSCredentialsProviderChain.h>
#include <aws/core/utils/UUID.h>
#include <aws/core/utils/StringUtils.h>
#include <aws/core/utils/memory/stl/AWSAllocator.h>
#include <aws/s3/S3Client.h>
#include <aws/s3/model/CopyObjectRequest.h>
#include <aws/s3/model/CreateBucketRequest.h>
#include <aws/s3/model/DeleteBucketRequest.h>
#include <aws/s3/model/DeleteObjectRequest.h>
#include <aws/s3/model/GetObjectRequest.h>
#include <aws/s3/model/ListObjectsV2Request.h>
#include <aws/s3/model/PutObjectRequest.h>
#include <aws/s3/model/BucketLocationConstraint.h>
#include <aws/s3/model/CreateBucketConfiguration.h>
#include <aws/s3/model/ListObjectsRequest.h>
#include <iostream>
#include <fstream>
#include <memory>

int main(int argc, char** argv) {
    const std::string USAGE =
        "\n"
        "To run this example, supply the name of a bucket to create!\n"
        "Ex: ListBuckets <unique-bucket-name>\n";

    if (argc < 2) {
        std::cout << USAGE;
        return 1;
    }

    Aws::SDKOptions options;
    Aws::InitAPI(options);
    {
        Aws::Client::ClientConfiguration config;
        config.scheme = Aws::Http::Scheme::HTTP;
        config.httpRequestTimeoutMs = 1'000l;
        config.connectTimeoutMs = 1'000l;
        config.requestTimeoutMs = 1'000l;
        auto retryStrategy = std::make_shared<Aws::Client::StandardRetryStrategy>(1); // strategy with custom max retries
        config.retryStrategy = retryStrategy;
        Aws::S3::S3Client client(std::make_shared<Aws::Auth::DefaultAWSCredentialsProviderChain>(), config,
                                 Aws::Client::AWSAuthV4Signer::PayloadSigningPolicy::Never /* signPayloads */,
                                 false /* useVirtualAddressing */);
        // 1. Create a bucket
        std::string bucket_name = argv[1];
        std::cout << "Creating S3 bucket: " << bucket_name << std::endl;
        Aws::S3::Model::CreateBucketRequest request;
        request.SetBucket(bucket_name);
        Aws::S3::Model::CreateBucketOutcome outcome = client.CreateBucket(request);
        if (!outcome.IsSuccess()) {
            std::cout << "Failed to create a bucket: " << outcome.GetError().GetMessage() << std::endl;
        }
        std::cout << "Finish Create Bucket Test!" << std::endl;
        // 2. Get a object
        std::cout << "Getting S3 object: " << "from_bucket/object_key" << std::endl;
        Aws::S3::Model::GetObjectRequest gorequest;
        gorequest.SetBucket("from_bucket");
        gorequest.SetKey("object_key");
        auto gooutcome = client.GetObject(gorequest);
        if (!gooutcome.IsSuccess()) {
            std::cout << "Failed to get a object: " << gooutcome.GetError().GetMessage() << std::endl;
        }
        std::cout << "Finish Get Object Test!" << std::endl;
        // 3. Put a object
        std::cout << "Putting S3 object: " << "to_bucket/object_key" << std::endl;
        Aws::S3::Model::PutObjectRequest porequest;
        porequest.SetBucket("to_bucket");
        porequest.SetKey("object_key");
        auto input_data = Aws::MakeShared<Aws::FStream>("sSampleAllocationtTag", nullptr, std::ios_base::in | std::ios_base::binary);
        porequest.SetBody(input_data);
        auto pooutcome = client.PutObject(porequest);
        if (!pooutcome.IsSuccess()) {
            std::cout << "Failed to put a object: " << pooutcome.GetError().GetMessage() << std::endl;
        }
        std::cout << "Finish Put Object Test!" << std::endl;
        // 4. Delete a object
        std::cout << "Deleing S3 object: " << "bucket_name/object_key" << std::endl;
        Aws::S3::Model::DeleteObjectRequest dorequest;
        dorequest.WithKey("objcet_key").WithBucket("bucket_name");
        auto dooutcome = client.DeleteObject(dorequest);
        if (!dooutcome.IsSuccess()) {
            std::cout << "Failed to delete a object: " << pooutcome.GetError().GetMessage() << std::endl;
        }
        std::cout << "Finish Delete Object Test!" << std::endl;
        // 5. List objects
        std::cout << "Listing S3 objects: " << "bucket_name/prefix*" << std::endl;
        Aws::S3::Model::ListObjectsRequest lorequest;
        lorequest.WithBucket("bucket_name");
        lorequest.SetPrefix("prefix");
        auto looutcome = client.ListObjects(lorequest);
        if (!looutcome.IsSuccess()) {
            std::cout << "Failed to delete a object: " << looutcome.GetError().GetMessage() << std::endl;
        }
        std::cout << "Finish List Objects Test!" << std::endl;

        std::cout << "Finish AWS test!" << std::endl;
    }
    Aws::ShutdownAPI(options);
    return 0;
}
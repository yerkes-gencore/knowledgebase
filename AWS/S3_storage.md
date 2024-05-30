# Retrieve file from Glacier

To retrieve a file from Glacier storage you first restore the file (object) and then either download or copy it to a new location that is not Glacier class.

## Using aws-cli commands

As of now (May 2024) need an active tki credential

### restore-object

https://docs.aws.amazon.com/cli/latest/reference/s3api/restore-object.html

Basic example:

aws s3api restore-object --bucket <bucketID> --key <filepath> --restore-request Days=5

Haven't determined a way to do this for a "directory"; you have to to it for all files.

### check restore status with head-object

https://docs.aws.amazon.com/cli/latest/reference/s3api/head-object.html

Basic example:

aws s3api head-object --bucket <bucketID> --key <filepath>

If result contains something like:

"Restore": "ongoing-request=\"true\""

then the restore is still in progress.

If result contains something like:

"Restore": "ongoing-request=\"false\", expiry-date=\"Sun, 17 Mar 2024 00:00:00 GMT\""

Then the object is available to work with.



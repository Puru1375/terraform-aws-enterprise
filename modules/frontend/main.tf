resource "aws_s3_bucket" "frontend" {
  bucket = "${var.name_prefix}-frontend"

  force_destroy = true

  tags = merge(
    var.common_tags,
    {
      Name = "${var.name_prefix}-frontend"
      Tier = "frontend"
    }
  )
}

resource "aws_s3_bucket_public_access_block" "frontend" {
  bucket = aws_s3_bucket.frontend.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "frontend" {
  bucket = aws_s3_bucket.frontend.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "frontend" {
  bucket = aws_s3_bucket.frontend.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_cloudfront_origin_access_control" "frontend" {
  name                              = "${var.name_prefix}-frontend-oac"
  description                       = "OAC for ${var.name_prefix} frontend"
  origin_access_control_origin_type = "s3"

  signing_behavior = "always"
  signing_protocol = "sigv4"
}

resource "aws_cloudfront_distribution" "frontend" {
  enabled = true

  comment = "${var.name_prefix} frontend distribution"

  default_root_object = "index.html"

  # ============================================================
  # S3 ORIGIN
  # ============================================================

  origin {
    domain_name = aws_s3_bucket.frontend.bucket_regional_domain_name

    origin_id = "S3-${aws_s3_bucket.frontend.id}"

    origin_access_control_id = aws_cloudfront_origin_access_control.frontend.id
  }

  # ============================================================
  # ALB ORIGIN
  # ============================================================

  origin {
    domain_name = var.alb_dns_name

    origin_id = "alb-backend"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"

      origin_ssl_protocols = [
        "TLSv1.2"
      ]
    }
  }

  # ============================================================
  # DEFAULT BEHAVIOR
  # React frontend → S3
  # ============================================================

  default_cache_behavior {
    target_origin_id = "S3-${aws_s3_bucket.frontend.id}"

    allowed_methods = [
      "GET",
      "HEAD",
      "OPTIONS"
    ]

    cached_methods = [
      "GET",
      "HEAD"
    ]

    viewer_protocol_policy = "redirect-to-https"

    compress = true

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
  }

  # ============================================================
  # API BEHAVIOR
  # /api/* → ALB → ECS
  # ============================================================

  ordered_cache_behavior {
    path_pattern = "/api/*"

    target_origin_id = "alb-backend"

    allowed_methods = [
      "DELETE",
      "GET",
      "HEAD",
      "OPTIONS",
      "PATCH",
      "POST",
      "PUT"
    ]

    cached_methods = [
      "GET",
      "HEAD"
    ]

    viewer_protocol_policy = "redirect-to-https"

    compress = true

    forwarded_values {
      query_string = true

      cookies {
        forward = "all"
      }
    }
  }

  # ============================================================
  # SPA ERROR HANDLING
  # ============================================================

  custom_error_response {
    error_code            = 403
    response_code         = 200
    response_page_path    = "/index.html"
    error_caching_min_ttl = 0
  }

  custom_error_response {
    error_code            = 404
    response_code         = 200
    response_page_path    = "/index.html"
    error_caching_min_ttl = 0
  }

  # ============================================================
  # RESTRICTIONS
  # ============================================================

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  # ============================================================
  # HTTPS
  # ============================================================

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  # ============================================================
  # TAGS
  # ============================================================

  tags = merge(
    var.common_tags,
    {
      Name = "${var.name_prefix}-frontend-cdn"
      Tier = "frontend"
    }
  )
}

data "aws_iam_policy_document" "frontend_bucket_policy" {
  statement {
    sid    = "AllowCloudFrontRead"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    actions = [
      "s3:GetObject"
    ]

    resources = [
      "${aws_s3_bucket.frontend.arn}/*"
    ]

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"

      values = [
        aws_cloudfront_distribution.frontend.arn
      ]
    }
  }
}

resource "aws_s3_bucket_policy" "frontend" {
  bucket = aws_s3_bucket.frontend.id

  policy = data.aws_iam_policy_document.frontend_bucket_policy.json
}
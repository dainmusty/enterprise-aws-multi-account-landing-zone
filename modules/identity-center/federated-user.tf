# resource "aws_iam_saml_provider" "azure_ad" {
 

#   name                   = "AzureAD"
#   saml_metadata_document = file("${path.module}/saml/azuread-metadata.example.xml")# This file contains the SAML metadata for Azure AD, which is used to configure the SAML provider in AWS IAM.
# It should look like the shortened example below, but with the actual values from your Azure AD tenant. You can obtain this metadata from the Azure portal under the Enterprise Applications section for your AWS SSO application.:

# }
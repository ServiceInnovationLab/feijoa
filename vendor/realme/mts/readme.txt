================================================================================
   MTS Resources
================================================================================

========================
A. Keys and Certificates
========================
This site requires the use of the following pre-configured keys and certificates:

  1. A Service Provider SAML signing private key. Used to sign SAML requests to
     the MTS IdP. The associated Service Provider signing certificate will be
     held on the MTS SAML IdP to validate signatures.

  2. An MTS IdP SAML signing certificate for the Login MTS and an MTS IdP signing
     certificate for the assert MTS. Used to check signatures in MTS IdP
     SAML responses.

  3. A Service Provider key - pair to make the mutual SSL backchannel call from
     your SAML SP to the MTS SAML IdP. A pair are required for the dual site
     backchannels.

  4. A MTS IdP certificate to receive the mutual SSL backchannel reply from the
     MTS SAML IdP.


The certificates are in Internet RFC 1421 standard, also known as Base 64 encoding.
These are :
  mts_login_saml_idp.cer       (for [2] )
  mts_assert_saml_idp.cer      (for [2] )
  mts_mutual_ssl_idp.cer       (for [4] )


The private keys are in pkcs#8 (pem) format. These files are:
  mts_saml_sp.pem           (for [1] )
  mts_mutualssl_saml_sp.pem (for [3] )


The public keys are in Internet RFC 1421 standard, also known as Base 64 encoding.
These are :
  mts_saml_sp.cer           (for [1] )
  mts_mutualssl_saml_sp.cer (for [3] )


The private keys are also supplied in  pkcs#12 (p12) format. These files are:
  mts_saml_sp.p12           (for [1] )
  mts_mutualssl_saml_sp.p12 (for [3] )

The password to the p12 files are 'password'

========================
B. MTS IdP SAML Metadata
========================
Two MTS IdP SAML2 metadata files are also published to aid your SP SAML product
integration with the MTS.

This is contained in the files : 
  MTSIdPLoginSAMLMetadata.xml    (for login service integration)
  MTSIdPAssertSAMLMetadata.xml   (for assertion service integration)

Note that these files also contain the MTS IdP SAML signing certificates which is
the same as contained in mts_login_saml_idp.cer and mts_assert_saml_idp.cer.

========================
C. SAML SP Metadata
========================
Two sample SP SAML2 metadata files are also published to aid your integration with
the MTS.

This is contained in the files : 
  MTSSP_ArtefactBiding_Sample.xml
  MTSSP_PostBinding_Sample.xml 

Note these files also contains the expected SP SAML signing certificate.
This is the certificate for the provided Service Provider SAML signing key-pair
as contained in mts_saml_sp.p12.

const clientId = "503796o07f491k7hs1gd9l2b1r";

const cognitoDomain =
  "https://cloud-snap-roshan-bucket-suffix.auth.us-east-1.amazoncognito.com";

const websiteDomain = "http://localhost:5173";

export const apiEndpoint =
  "https://c54rt3ge2a.execute-api.us-east-1.amazonaws.com/cloud-snap";

export const landingPage = `${websiteDomain}/landing`;

export const loginURL = `${cognitoDomain}/login?client_id=${clientId}&response_type=token&scope=email+openid+profile&redirect_uri=${websiteDomain}/signedin`;

export const logoutURL = `${cognitoDomain}/logout?client_id=${clientId}&logout_uri=${landingPage}`;

export const signUpURL = `${cognitoDomain}/signup?client_id=${clientId}&response_type=token&scope=email+openid+phone+profile&redirect_uri=${websiteDomain}/signedin`;

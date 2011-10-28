package server.java;

import com.paypal.sdk.profiles.APIProfile;
import com.paypal.sdk.profiles.SignatureAPIProfile;

public class Common {
	
	public static APIProfile getAPIProfile() {
		APIProfile profile = new SignatureAPIProfile();
		try {
			//profile.setAPIUsername("YOUR API USER NAME");
			//profile.setAPIPassword("YOUR API PASSWORD");
			//profile.setSignature("YOUR API SIGNATURE");			
			profile.setEnvironment("sandbox");
			profile.setSubject("");
		} catch (Exception ex) {
			
		}
		return profile;
	}
}

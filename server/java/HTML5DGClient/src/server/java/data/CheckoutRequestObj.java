package server.java.data;

public class CheckoutRequestObj {
	private String methodName;
	private String token;
	private String payerId;
	private double amount;
	private String paymentType;
	private String currencyCode;
	private String returnURL;
	private String cancelURL;
	private int qty;
	private String name;

	public String getUserInfo() {
		return userInfo;
	}

	public void setUserInfo(String userInfo) {
		this.userInfo = userInfo;
	}

	public String getShipmentAmt() {
		return shipmentAmt;
	}

	public void setShipmentAmt(String shipmentAmt) {
		this.shipmentAmt = shipmentAmt;
	}

	public String getShipDiscAmt() {
		return shipDiscAmt;
	}

	public void setShipDiscAmt(String shipDiscAmt) {
		this.shipDiscAmt = shipDiscAmt;
	}

	public String getTaxAmt() {
		return taxAmt;
	}

	public void setTaxAmt(String taxAmt) {
		this.taxAmt = taxAmt;
	}

	public String getInsuranceAmt() {
		return insuranceAmt;
	}

	public void setInsuranceAmt(String insuranceAmt) {
		this.insuranceAmt = insuranceAmt;
	}

	private String number;
	private String desc;
	private double amount0;
	private String userInfo;
	private String shipmentAmt;
	private String shipDiscAmt;
	private String taxAmt;
	private String insuranceAmt;

	public double getAmount0() {
		return amount0;
	}

	public void setAmount0(double amount0) {
		this.amount0 = amount0;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getNumber() {
		return number;
	}

	public void setNumber(String number) {
		this.number = number;
	}

	public String getDesc() {
		return desc;
	}

	public void setDesc(String desc) {
		this.desc = desc;
	}

	public int getQty() {
		return qty;
	}

	public void setQty(int qty) {
		this.qty = qty;
	}

	public String getMethodName() {
		return methodName;
	}

	public void setMethodName(String methodName) {
		this.methodName = methodName;
	}

	public String getToken() {
		return token;
	}

	public void setToken(String token) {
		this.token = token;
	}

	public String getPayerId() {
		return payerId;
	}

	public void setPayerId(String payerId) {
		this.payerId = payerId;
	}

	public double getAmount() {
		return amount;
	}

	public void setAmount(double price) {
		this.amount = price;
	}

	public String getPaymentType() {
		return paymentType;
	}

	public void setPaymentType(String paymentType) {
		this.paymentType = paymentType;
	}

	public String getCurrencyCode() {
		return currencyCode;
	}

	public void setCurrencyCode(String currencyCode) {
		this.currencyCode = currencyCode;
	}

	public String getReturnURL() {
		return returnURL;
	}

	public void setReturnURL(String returnURL) {
		this.returnURL = returnURL;
	}

	public String getCancelURL() {
		return cancelURL;
	}

	public void setCancelURL(String cancelURL) {
		this.cancelURL = cancelURL;
	}

}

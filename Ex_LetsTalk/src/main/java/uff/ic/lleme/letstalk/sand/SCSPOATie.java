package uff.ic.lleme.letstalk.sand;

/**
 * SCSPOATie.java . Generated by the IDL-to-Java compiler (portable), version
 * "3.2" from scs.idl Friday, December 9, 2005 9:35:21 PM GMT
 */

public class SCSPOATie extends SCSPOA {

	// Constructors

	public SCSPOATie(SCSOperations delegate) {
		this._impl = delegate;
	}

	public SCSPOATie(SCSOperations delegate, org.omg.PortableServer.POA poa) {
		this._impl = delegate;
		this._poa = poa;
	}

	public SCSOperations _delegate() {
		return this._impl;
	}

	public void _delegate(SCSOperations delegate) {
		this._impl = delegate;
	}

	public org.omg.PortableServer.POA _default_POA() {
		if (_poa != null) {
			return _poa;
		} else {
			return super._default_POA();
		}
	}

	public IComponent getIComponent(String className, int instance_id)
			throws InternalError {
		return _impl.getIComponent(className, instance_id);
	} // getIComponent

	public IComponent releaseIComponent(String className, int instance_id) {
		return _impl.releaseIComponent(className, instance_id);
	} // releaseIComponent

	private SCSOperations _impl;

	private org.omg.PortableServer.POA _poa;

} // class SCSPOATie

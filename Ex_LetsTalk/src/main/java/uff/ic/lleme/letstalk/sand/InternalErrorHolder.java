package uff.ic.lleme.letstalk.sand;

/**
 * InternalErrorHolder.java . Generated by the IDL-to-Java compiler (portable),
 * version "3.2" from scs.idl Friday, December 9, 2005 9:35:21 PM GMT
 */

public final class InternalErrorHolder implements
		org.omg.CORBA.portable.Streamable {
	public InternalError value = null;

	public InternalErrorHolder() {
	}

	public InternalErrorHolder(InternalError initialValue) {
		value = initialValue;
	}

	public void _read(org.omg.CORBA.portable.InputStream i) {
		value = InternalErrorHelper.read(i);
	}

	public void _write(org.omg.CORBA.portable.OutputStream o) {
		InternalErrorHelper.write(o, value);
	}

	public org.omg.CORBA.TypeCode _type() {
		return InternalErrorHelper.type();
	}

}
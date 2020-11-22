module dismal.http.auth;

enum AuthType
{
    /// No authorization is required
    none,

    /// The endpoint requires a secret token (Authorization <token>)
    secret
}

/** 
 * Provides an abstraction over the different authentication flows. For most cases, using `secretToken`
 * is required since most (if not all) Discord endpoints require an Authorization token and this endpoint takes one.
 */
class AuthProvider
{
private:
    string _token;
    AuthType _type;

    this(string token, AuthType type) {
        this._token = token;
        this._type = type;
    }

public:
    AuthType getType() @safe {
        return this._type;
    }

    string getUnderlyingToken() @safe {
        return this._token;
    }

    static AuthProvider secretToken(string token) {
        return new AuthProvider(token, AuthType.secret);
    }

    static AuthProvider none() {
        return new AuthProvider("", AuthType.none);
    }
}
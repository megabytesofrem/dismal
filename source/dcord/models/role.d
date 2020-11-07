module dcord.models.role;

struct Role
{
    string id;
    string name;
    int color;
    bool hoist;
    int position;
    string permissions_new;
    int permissions;
    bool managed;
    bool mentionable;
}
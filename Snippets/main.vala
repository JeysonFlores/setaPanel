using Gtk;
//Button button;
static int cant = 0;

public static int main (string[] args) {
    Gtk.init (ref args);
    try {
        var builder = new Builder();
        builder.add_from_file ("/home/jeyson/Descargas/PureX2.glade");
        builder.connect_signals (null);
        CssProvider css_provider = new Gtk.CssProvider ();
        css_provider.load_from_path ("/home/jeyson/Documentos/css.css");
        Gtk.StyleContext.add_provider_for_screen (Gdk.Screen.get_default (), css_provider,      Gtk.STYLE_PROVIDER_PRIORITY_USER);
        var window = builder.get_object ("window_main") as Window;
        window.destroy.connect (Gtk.main_quit);
        var button  = builder.get_object ("gotoapp") as Button;
        var button2  = builder.get_object ("gotofolder") as Button;
        var button3  = builder.get_object ("gotophp") as Button;
        var help_button  = builder.get_object ("help") as Button;
        var info_button  = builder.get_object ("info") as Button;
        var proftpd_button  = builder.get_object ("proftpd_button") as Button;
        var mysql_button  = builder.get_object ("mysql_button") as Button;
        //button = new Button.with_label ("Start counting");
        
        var stop_all  = builder.get_object ("stop_all") as Button;
        var restart_all  = builder.get_object ("restart_all") as Button;
        var start_all  = builder.get_object ("start_all") as Button;
        var reload = builder.get_object ("reload") as Button;
        
        var status_apache = builder.get_object ("status_apache") as Image;
        var status_mysql = builder.get_object ("status_mysql") as Image;
        var status_proftpd = builder.get_object ("status_proftpd") as Image;
        
        var apache_button  = builder.get_object ("apache_button") as Button;
        apache_button.clicked.connect (() => {
             startapache.begin (status_apache, apache_button, stop_all, restart_all, start_all,  reload,(obj, async_res) => {
                GLib.debug ("Finished loading.");
            });
        });
        
        proftpd_button.clicked.connect (() => {
        
           // proftpdshutter(proftpd_button);
           startproftpd.begin (status_proftpd, proftpd_button, stop_all, restart_all, start_all,  reload,(obj, async_res) => {
                GLib.debug ("Finished loading.");
            });
        });
        
        mysql_button.clicked.connect (() => {
            //mysqlshutter(mysql_button);
            startmysql.begin (status_mysql, mysql_button,  stop_all, restart_all, start_all,  reload,(obj, async_res) => {
                GLib.debug ("Finished loading.");
            });
        });
        
        help_button.clicked.connect (() => {
            helpdialog();
        });
        
        info_button.clicked.connect (() => {
            infodialog();
        });
        
        button.clicked.connect (() => {
            openxbrowser_filedir("http://localhost/");
            openxbrowser_filedir.begin ("http://localhost/", (obj, async_res) => {
                GLib.debug ("Finished loading.");
            });
        });
        
        button2.clicked.connect (() => {
          //  count ();
          openxbrowser_filedir("/opt/lampp/htdocs/");
        });
        
        button3.clicked.connect (() => {
          //  count ();
          openxbrowser_filedir("http://localhost/phpmyadmin/index.php");
        });

        //window.add (button);
        window.show_all ();
        Gtk.main ();
     } catch (Error e) {
        stderr.printf ("Could not load UI: %s\n", e.message);
        return 1;
    }
    return 0;
}

static void helpdialog( ){
    try{
        var builder = new Builder();
        builder.add_from_file ("/home/jeyson/Descargas/PureX2.glade");
        builder.connect_signals (null);
        var help_dialog = builder.get_object ("helpdialog") as Dialog;
        help_dialog.show_all();
    }
    catch(Error e) {
        stderr.printf ("Could not load UI: %s\n", e.message);
    }
}

static void infodialog( ){
    try{
        var builder = new Builder();
        builder.add_from_file ("/home/jeyson/Descargas/PureX2.glade");
        builder.connect_signals (null);
        CssProvider css_provider = new Gtk.CssProvider ();
        css_provider.load_from_path ("/home/jeyson/Documentos/css.css");
        Gtk.StyleContext.add_provider_for_screen (Gdk.Screen.get_default (), css_provider,          Gtk.STYLE_PROVIDER_PRIORITY_USER);
        var info_dialog  = new Dialog();
        info_dialog = builder.get_object ("infodialog") as Dialog;
        info_dialog.show_all();
    }
    catch(Error e) {
        stderr.printf ("Could not load UI: %s\n", e.message);
    }
}

/*async void count(){
    for(int i = 0; i < 10000; i++){
        button.label = i.to_string();
        Idle.add (count.callback);
        yield;
    }
} */


async void startapache(Image status, Button button, Button start, Button restart, Button stop, Button reload) {
    button.set_sensitive(false);
    start.set_sensitive(false);
    restart.set_sensitive(false);
    stop.set_sensitive(false);
    reload.set_sensitive(false);
    status.set_from_icon_name("user-away", IconSize.BUTTON);
    cant++;
    string action = "";
    if(button.label == "Start")
        action = "start";
    else
        action = "stop";
    new Thread<void*> ("",() => {
         string ls_stdout;
          string ls_stderr;
          int ls_status;
         try {
            Process.spawn_command_line_sync ("pkexec sh /opt/lampp/apache2/scripts/ctl.sh "+action,
                                    out ls_stdout,
                                    out ls_stderr,
                                    out ls_status);
            
         print ("Status: %d\n", ls_status);
        Idle.add(() => {
            if (button.label == "Start") {
                 button.label = "Stop";
                 status.set_from_icon_name("user-available", IconSize.BUTTON);
            }
            else{
                if(button.label == "Stop")
                    button.label = "Start";
                    status.set_from_icon_name("user-busy", IconSize.BUTTON);
            }
            button.set_sensitive(true);
            cant--;
              if(cant==0){
                    start.set_sensitive(true);
                    restart.set_sensitive(true);
                    stop.set_sensitive(true);
                    reload.set_sensitive(true);
                }
            return Source.REMOVE;
        });
        
         } catch (SpawnError e) {
        print ("Error: %s\n", e.message);
         }
        return null;
    });
}

async void startmysql(Image status,Button button, Button start, Button restart, Button stop, Button reload) {
     button.set_sensitive(false);
    start.set_sensitive(false);
    restart.set_sensitive(false);
    stop.set_sensitive(false);
    reload.set_sensitive(false);
    //status = new Image.from_icon_name("user-away", IconSize.BUTTON);
    status.set_from_icon_name("user-away", IconSize.BUTTON);
    cant++;
    string action = "";
    if(button.label == "Start")
        action = "start";
    else
        action = "stop";
    new Thread<void*> ("",() => {
         string ls_stdout;
          string ls_stderr;
          int ls_status;
         try {
            Process.spawn_command_line_sync ("pkexec sh /opt/lampp/mysql/scripts/ctl.sh "+action,
                                    out ls_stdout,
                                    out ls_stderr,
                                    out ls_status);
            
         print ("Status: %d\n", ls_status);
        Idle.add(() => {
            if (button.label == "Start") {
                 button.label = "Stop";
                 status.set_from_icon_name("user-available", IconSize.BUTTON);
            }
            else{
                if(button.label == "Stop")
                    button.label = "Start";
                    status.set_from_icon_name("user-busy", IconSize.BUTTON);
            }
              button.set_sensitive(true);
              cant--;
              if(cant==0){
                    start.set_sensitive(true);
                    restart.set_sensitive(true);
                    stop.set_sensitive(true);
                    reload.set_sensitive(true);
                }
            return Source.REMOVE;
        });
        
         } catch (SpawnError e) {
        print ("Error: %s\n", e.message);
         }
        return null;
    });
}

async void startproftpd(Image status, Button button, Button start, Button restart, Button stop, Button reload) {
    button.set_sensitive(false);
    start.set_sensitive(false);
    restart.set_sensitive(false);
    stop.set_sensitive(false);
    reload.set_sensitive(false);
    status.set_from_icon_name("user-away", IconSize.BUTTON);
    cant++;
    string action = "";
    if(button.label == "Start")
        action = "start";
    else
        action = "stop";
    new Thread<void*> ("",() => {
         string ls_stdout;
          string ls_stderr;
          int ls_status;
         try {
            Process.spawn_command_line_sync ("pkexec sh /opt/lampp/proftpd/scripts/ctl.sh "+action,
                                    out ls_stdout,
                                    out ls_stderr,
                                    out ls_status);
            
         print ("Status: %d\n", ls_status);
        Idle.add(() => {
            if (button.label == "Start") {
               button.label = "Stop";
               status.set_from_icon_name("user-available", IconSize.BUTTON);
            }
            else{
                if(button.label == "Stop")
                    button.label = "Start";
                    status.set_from_icon_name("user-busy", IconSize.BUTTON);
            }
            cant--;
            button.set_sensitive(true);
            if (cant==0){
                start.set_sensitive(true);
                restart.set_sensitive(true);
                stop.set_sensitive(true);
                reload.set_sensitive(true);
            }
            return Source.REMOVE;
        });
        
         } catch (SpawnError e) {
        print ("Error: %s\n", e.message);
         }
        return null;
    });
}


         
async void openxbrowser_filedir(string dir) {
        new Thread<void*> ("",() => {
         string ls_stdout;
          string ls_stderr;
          int ls_status;
         try {
            Process.spawn_command_line_sync ("xdg-open " + dir,
                                    out ls_stdout,
                                    out ls_stderr,
                                    out ls_status);
            
         print ("Status: %d\n", ls_status);
         print ("Status: %s\n", ls_stdout);
         print ("Status: %s\n", ls_stderr);
        }
        catch (SpawnError e) {
        print ("Error: %s\n", e.message);
         }
        return null;
    });
}



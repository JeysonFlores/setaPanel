using Gtk;
//Button button;

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
        
        var apache_button  = builder.get_object ("apache_button") as Button;
        apache_button.clicked.connect (() => {
             startapache.begin (apache_button, (obj, async_res) => {
                GLib.debug ("Finished loading.");
            });
        });
        
        proftpd_button.clicked.connect (() => {
           // proftpdshutter(proftpd_button);
           startproftpd.begin (proftpd_button, (obj, async_res) => {
                GLib.debug ("Finished loading.");
            });
        });
        
        mysql_button.clicked.connect (() => {
            //mysqlshutter(mysql_button);
            startmysql.begin (mysql_button, (obj, async_res) => {
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


async void startapache(Button button) {
    button.set_sensitive(false);
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
            }
            else{
                if(button.label == "Stop")
                    button.label = "Start";
            }
            button.set_sensitive(true);
            return Source.REMOVE;
        });
        
         } catch (SpawnError e) {
        print ("Error: %s\n", e.message);
         }
        return null;
    });
}

async void startmysql(Button button) {
    button.set_sensitive(false);
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
            }
            else{
                if(button.label == "Stop")
                    button.label = "Start";
            }
            button.set_sensitive(true);
            return Source.REMOVE;
        });
        
         } catch (SpawnError e) {
        print ("Error: %s\n", e.message);
         }
        return null;
    });
}

async void startproftpd(Button button) {
    button.set_sensitive(false);
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
            }
            else{
                if(button.label == "Stop")
                    button.label = "Start";
            }
            button.set_sensitive(true);
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

# OIDC Settings in Microsoft Entra ID

Owners and admins can configure OIDC settings for an organization on the PDQ portal.

## Requirements

1. You will need to have the Microsoft portal open along with the PDQ portal.
2. You will need the Cloud Application Administrator role activated.

## Create a New Enterprise Application in the Entra Portal

1. Browse to the Microsoft Entra portal at https://entra.microsoft.com/.
2. In the left pane, under Applications, click **Enterprise applications**.
3. On the Enterprise applications page, click the **+ New application** button.
4. Enter a name for your application. For example: **Logixhealth OIDC PDQ logon**.
5. Click the **Create** button.

Your new application will be created, and you will be taken to the Overview page for that app. You can also find this page by returning to the Enterprise applications page and searching for your newly created application.

## Create a New App Registration

This will allow you to retrieve and add the Document Discovery URI and Client ID to the OIDC settings.

1. Browse to the Microsoft Entra portal at https://entra.microsoft.com/.
2. In the left pane, under Applications, click **App registrations**.
3. Click on **All Applications**, search for the application you created above, and click on that application's name. You will be taken to the app registration page for that application.
4. Click the **Endpoints** button.
5. In the Endpoints tab, select the URI for **OpenID Connect metadata document** (near the bottom of the list), and copy it to your clipboard.
6. Return to the PDQ Portal account settings (https://portal.pdq.com/account), scroll down to the OIDC settings, and paste the URI into the **Discovery Document URI** field.
7. Return to the app registration page on the Entra portal (and close the Endpoints tab by clicking the 'X' button).
8. On the Overview tab, under Essentials, locate the **Application (client) ID**, and click the button to the right of the GUID value to copy it to the clipboard.
9. Return to the PDQ Portal account settings, scroll down to the OIDC settings, and paste the GUID into the **Client ID** field.

## Create a New Client Secret

This procedure will allow you to generate a new client secret to add to the OIDC settings.

1. Return to the Entra app registration page for the app created above, and then switch to the **Manage | Certificates & secrets** tab.
2. In the Client secrets tab, click the **New client secret** button.
3. In the **Add a client secret** tab, enter a description (e.g., "PDQ Portal"), set an expiration date, and then click the **Add** button to confirm.
4. Back in the Client secrets tab, locate the secret you just created, and click the button to copy the **Value** of that secret to the clipboard. The Value will only be displayed once, at the time of creation, so be sure to complete the OIDC settings procedure before closing or browsing away from this tab. Copy the Value only - the Secret ID is not needed. If needed, you can always recreate it.
5. Return to the PDQ Portal account settings, scroll down to the OIDC settings, and paste the Value into the **Client Secret** field.
6. Scroll to the top of the PDQ Portal account settings and click the **Save changes** button.

Once saved, scroll back to the OIDC settings, where additional information will now be present.

## Add the Redirect URI for the PDQ Portal to Entra

1. On the PDQ Portal account settings, scroll down to the OIDC settings, and copy the **Redirect URI** to the clipboard.
2. Return to the Entra app registration page for the app created above, switch to the **Manage | Authentication** tab, and then click **+Add a platform**.
3. In the **Configure Platforms** tab, click **Web**.
4. In the **Configure Web** tab, paste the Redirect URI into the text field, and click **Configure**.

## Configure Login Permissions for Your Application

1. Browse to the Microsoft Entra portal at https://entra.microsoft.com/.
2. In the left pane, under Applications, click **Enterprise applications**.
3. Click on **All Applications**, search for the app you created above, and click on that app's name.
4. On the Entra Enterprise app page, switch to the **Manage | Users and Groups** tab.
5. Click **Add user/group**. Select one or more users and/or user groups and click **Select**, then click **Assign**.
6. For example, our **PDQConnect_SSO_Access_Users** is a group we created which has all the users who will need access to PDQ Connect.

This configuration will grant your users the appropriate permissions to log into PDQ using your OIDC application. You will need to invite each user into your PDQ organization.

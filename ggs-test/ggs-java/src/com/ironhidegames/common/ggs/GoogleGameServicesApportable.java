package com.ironhidegames.common.ggs;

import android.util.Log;
import android.os.Bundle;
import android.content.Intent;
import android.app.Activity;

import android.app.ProgressDialog;
import android.graphics.Bitmap;
import android.os.AsyncTask;
import android.os.Bundle;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.Button;
import android.widget.RatingBar;
import android.widget.RatingBar.OnRatingBarChangeListener;
import android.widget.TextView;
import android.widget.Toast;

import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.api.GoogleApiClient;
import com.google.android.gms.drive.Drive;
import com.google.android.gms.games.Games;
import com.google.android.gms.games.GamesStatusCodes;
import com.google.android.gms.games.snapshot.Snapshot;
import com.google.android.gms.games.snapshot.SnapshotMetadata;
import com.google.android.gms.games.snapshot.SnapshotMetadataChange;
import com.google.android.gms.games.snapshot.Snapshots;
import com.google.android.gms.plus.Plus;

import com.apportable.activity.VerdeActivity;

public class GoogleGameServicesApportable implements GoogleApiClient.ConnectionCallbacks, GoogleApiClient.OnConnectionFailedListener
{
    private final String TAG = "GoogleGameServicesApportable";
    
    public final static int CLIENT_NONE = 0x00;
    public final static int CLIENT_GAMES = 0x01;
    public final static int CLIENT_PLUS = 0x02;
    public final static int CLIENT_SNAPSHOT = 0x04;
    
    public final static int CLIENT_ALL = CLIENT_GAMES | CLIENT_PLUS | CLIENT_SNAPSHOT;
    
    private static final int RC_SIGN_IN = 9001;
    
    public GoogleApiClient mGoogleApiClient;
    
    private boolean isSigningIn = false;
    private boolean shouldTrySignInResolution;
    
    private native void onConnectedCallback();
    private native void onConnectionFailedCallback();
    
//    private static GoogleGameServicesApportable ggsService;
//    
//    public static synchronized GoogleGameServicesApportable getInstance() {
//        if (ggsService == null) {
//            ggsService = new GoogleGameServicesApportable();
//        }
//        return ggsService;
//    }
    
    public GoogleGameServicesApportable()
    {
        
    }
    
    public void initGoogleApiClient(int clients)
    {
        VerdeActivity activity = VerdeActivity.getActivity();
        
        Log.d(TAG, "initApi");
        
        GoogleApiClient.Builder builder = new GoogleApiClient.Builder(activity, this, this);
        
        if ((clients & CLIENT_GAMES) != 0) {
            builder.addApi(Games.API);
            builder.addScope(Games.SCOPE_GAMES);
        }

        if ((clients & CLIENT_PLUS) != 0) {
            builder.addApi(Plus.API);
            builder.addScope(Plus.SCOPE_PLUS_LOGIN);
        }

        if ((clients & CLIENT_SNAPSHOT) != 0) {
            builder.addScope(Drive.SCOPE_APPFOLDER);
            builder.addApi(Drive.API);
        }
        
        mGoogleApiClient = builder.build();
    }
    
    public boolean isConnected() {
        return mGoogleApiClient != null && mGoogleApiClient.isConnected();
    }
    
    public void connect()
    {
        this.internalConnect(true);
    }
    
    public void silentConnect()
    {
        this.internalConnect(false);
    }
    
    private void internalConnect(boolean trySignInResolution) {
        if (this.isSigningIn) {
            Log.d(TAG, "it is already trying to connect");
            return;
        }
        
        if (this.isConnected()) {
            Log.d(TAG, "it is already connected");
            return;
        }

        this.shouldTrySignInResolution = trySignInResolution;
        
        Log.d(TAG, "connecting");
        mGoogleApiClient.connect();
        this.isSigningIn = true;
    }
    
    public void disconnect() {
        if (!this.isConnected()) {
            Log.d(TAG, "can't disconnect since it is not connected");
        } else {
            Log.d(TAG, "disconnecting");
            Games.signOut(mGoogleApiClient);
            mGoogleApiClient.disconnect();
            
            this.isSigningIn = false;
        }
    }
    
//    // @Override
//    protected void onActivityResult(int requestCode, int resultCode, Intent intent) {
//        if (requestCode == RC_SIGN_IN) {
//            Log.d(TAG, "onActivityResult with requestCode == RC_SIGN_IN, responseCode="
//                  + resultCode + ", intent=" + intent);
//
//            if (resultCode == Activty.RESULT_OK) {
//                this.connect();
//                // mGoogleApiClient.connect();
//            } else {
//                // TODO: copy base game utils
//                // BaseGameUtils.showActivityResultError(this, requestCode, resultCode, R.string.signin_other_error);
//            }
//        }
//    }
    
    @Override
    public void onConnected (Bundle connectionHint)
    {
        Log.d(TAG, "onConnected");
        this.isSigningIn = false;
        onConnectedCallback();
    }
    
    @Override
    public void onConnectionSuspended (int cause)
    {
        Log.d(TAG, "onConnectionSuspended: " + cause + ", trying to reconnect");
        mGoogleApiClient.connect();
    }
    
    @Override
    public void onConnectionFailed (ConnectionResult result)
    {
        int errorCode = result.getErrorCode();
        
        this.isSigningIn = false;
        
        Log.d(TAG, "onConnectionFailed: " + errorCode + ", " + result.isSuccess());
        if (errorCode == ConnectionResult.SIGN_IN_REQUIRED || errorCode == ConnectionResult.RESOLUTION_REQUIRED) {
            
            if (!this.shouldTrySignInResolution) {
                Log.d(TAG, "onConnectionFailed: resolution required but disabled for silent sign in.");
                this.onConnectionFailedCallback();
                return;
            }
            
            try {
                Log.d(TAG, "onConnectionFailed: trying resolution for sign in.");
                result.startResolutionForResult(VerdeActivity.getActivity(), RC_SIGN_IN);
            } catch (Exception e) {
                this.onConnectionFailedCallback();
                throw new RuntimeException(e);
            }
        } else {
            this.onConnectionFailedCallback();
        }
    }
    
}
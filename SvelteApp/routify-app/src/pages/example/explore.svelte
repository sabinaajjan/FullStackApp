
<script>
    import { url, goto } from '@roxi/routify';
    import axios from 'axios';

    let username;
    let firstName;
    let lastName;
    let address;
    let birthdate;
    let errorMsg;
    
    
    async function addOwner() {
        if (!username) {
            errorMsg = 'Please enter a username';
        } else if (!firstName) {
            errorMsg = 'Please enter a first name';
        } else if (!lastName) {
            errorMsg = 'Please enter a last name';
        } else if (!address) {
            errorMsg = 'Please enter an address'
        } else if (!birhdate) {
            errorMsg = 'Please enter a birthdate';
        } else {
            try {
                const json =  (await axios.post('http://localhost:4000/add_owner', { username, firstName, lastName, address, birthdate })).data;
                if (json.error) {
                    errorMsg = json.error;
                } else {
                    buildingName = description = errorMsg = '';
                }
            } catch(error) {
                console.log(error.response.data)
                errorMsg = error.response.data.error;

            }
  
        }


    }
    </script>

<svelte:head>Add Owner</svelte:head>

<h1>Add Owner</h1>

<form on:submit|preventDefault={addOwner}>
    <label for="username">Username</label>
    <input type="text" id="username" name="username" bind:value={username} />

    <label for="firstName">First Name</label>
    <textarea id="firstName" name="firstName" bind:value={firstName} />


    <label for="lastName">Last Name</label>
    <textarea id="lastName" name="lastName" bind:value={lastName} />

    <label for="address">Address</label>
    <textarea id="address" name="address" bind:value={address} />

    <label for="birthdate">Birthdate</label>
    <textarea id="birthdate" name="birthdate" bind:value={birthdate} />

 
    <button type="submit">Add</button>
    <button type="reset">Reset</button>
</form>

<a href={$url('../../home')}>Back</a>


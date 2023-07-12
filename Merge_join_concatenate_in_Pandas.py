#!/usr/bin/env python
# coding: utf-8

# # Merge,Join and Concatenate
# 
# ![join-types.png](attachment:join-types.png)

# In[2]:


import pandas as pd 


# In[12]:


df1 = pd.read_csv(r"D:\PortfolioProjects\PandasTutorials\LOTR.csv")
df1


# In[13]:


df2 = pd.read_csv(r"D:\PortfolioProjects\PandasTutorials\LOTR 2.csv")
df2


# In[17]:


df1.merge(df2, how = 'inner', on = ['FellowshipID','FirstName'])


# In[18]:


df1.merge(df2, how = 'outer')


# In[19]:


#NaN = not a number


# In[20]:


df1.merge(df2, how = 'left')


# In[21]:


df1.merge(df2, how = 'right')


# In[22]:


df1.merge(df2, how = 'cross')


# In[27]:


df1.join(df2, on = 'FellowshipID', how = 'outer', lsuffix = '_Left',rsuffix = '_Right' )


# In[32]:


df4 = df1.set_index('FellowshipID').join(df2.set_index('FellowshipID'), lsuffix = '_Left',rsuffix = '_Right', how = 'outer')
df4


# In[37]:


pd.concat([df1,df2], join = 'outer', axis = 1)


# In[38]:


df1.append(df2)


# 

# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:




